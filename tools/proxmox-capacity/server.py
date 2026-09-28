#!/usr/bin/env python3
"""Read-only MCP server for Proxmox and Prometheus capacity analysis.

The server intentionally uses only the Python standard library. Credentials are
read from ~/.env at request time and are never included in responses.
"""
from __future__ import annotations

import json
import os
import ssl
import sys
import urllib.parse
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

PVE_URL = "https://192.168.2.69:8006/api2/json"
PROM_URL = "http://prometheus.r.ss:9090"


def dotenv(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    try:
        lines = path.read_text().splitlines()
    except OSError:
        return values
    for line in lines:
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.removeprefix("export ").strip()
        value = value.strip().strip("'\"")
        values[key] = value
    return values


class Capacity:
    def __init__(self, opener=None, env_path: Path | None = None):
        self.opener = opener or urllib.request.urlopen
        self.env_path = env_path or Path.home() / ".env"

    def _open(self, request):
        return self.opener(request, context=ssl._create_unverified_context(), timeout=20)

    def pve(self, path: str):
        env = dotenv(self.env_path)
        token = env.get("PROXMOX_VE_API_TOKEN")
        if not token:
            raise RuntimeError("PROXMOX_VE_API_TOKEN is missing from ~/.env")
        req = urllib.request.Request(
            PVE_URL + path,
            headers={"Authorization": "PVEAPIToken=" + token},
        )
        with self._open(req) as response:
            return json.load(response)["data"]

    def prom(self, query: str, start=None, end=None, step="60s"):
        params = {"query": query}
        endpoint = "/api/v1/query"
        if start is not None:
            params.update(start=start, end=end, step=step)
            endpoint = "/api/v1/query_range"
        url = PROM_URL + endpoint + "?" + urllib.parse.urlencode(params)
        with self._open(urllib.request.Request(url)) as response:
            payload = json.load(response)
        if payload.get("status") != "success":
            raise RuntimeError(payload.get("error", "Prometheus query failed"))
        return payload["data"]["result"]

    @staticmethod
    def dedupe(results):
        """Drop cluster-wide duplicate exporter series by identity labels."""
        out = {}
        for item in results:
            labels = item.get("metric", {})
            identity = tuple(sorted((k, v) for k, v in labels.items() if k not in {"instance", "job"}))
            out.setdefault(identity, item)
        return list(out.values())

    def inventory(self):
        status = self.pve("/cluster/status")
        nodes = self.pve("/nodes")
        guests = self.pve("/cluster/resources?type=vm")
        storage = self.pve("/storage")
        return {"cluster": status, "nodes": nodes, "guests": guests, "storage": storage}

    def current_capacity(self):
        queries = {
            "nodes": "pve_node_info",
            "guest_info": "pve_guest_info",
            "memory_size": "pve_memory_size_bytes",
            "memory_used": "pve_memory_usage_bytes",
            "cpu_ratio": "pve_cpu_usage_ratio",
            "cpu_limit": "pve_cpu_usage_limit",
            "disk_size": "pve_disk_size_bytes",
            "disk_used": "pve_disk_usage_bytes",
        }
        return {name: self.dedupe(self.prom(query)) for name, query in queries.items()}

    def history(self, metric: str, start, end, step="5m"):
        allowed = {"pve_memory_usage_bytes", "pve_cpu_usage_ratio", "pve_disk_usage_bytes"}
        if metric not in allowed:
            raise ValueError("metric must be a supported capacity metric")
        # max is safe here because every exporter reports the same cluster value;
        # it collapses duplicate cluster-wide exporter series in Prometheus.
        query = f"max by (id,node,name) ({metric})"
        return {"metric": metric, "results": self.prom(query, start, end, step)}

    def placement(self):
        guests = self.pve("/cluster/resources?type=vm")
        return [
            {key: guest.get(key) for key in ("vmid", "type", "name", "node", "status", "maxcpu", "maxmem", "maxdisk", "tags")}
            for guest in sorted(guests, key=lambda x: (x.get("node", ""), x.get("vmid", 0)))
        ]

    def recommendations(self):
        data = self.inventory()
        nodes = {x["node"]: x for x in data["nodes"] if x.get("status") == "online"}
        guests = [x for x in data["guests"] if x.get("status") == "running"]
        protected_nodes = {"poweredge"}
        protected_guests = {"plex"}
        free = {
            node: {
                "cpu": max(0, info.get("maxcpu", 0) - sum(g.get("maxcpu") or 0 for g in guests if g.get("node") == node)),
                "memory": max(0, info.get("maxmem", 0) - sum(g.get("maxmem") or 0 for g in guests if g.get("node") == node)),
            }
            for node, info in nodes.items()
        }
        # N+1: leave the largest node's current allocation available, plus
        # 20% memory/CPU headroom for Kubernetes expansion.
        largest = max((x for x in free.values()), key=lambda x: (x["memory"], x["cpu"]), default={"cpu": 0, "memory": 0})
        k8s_reserve = {
            "cpu": max((x.get("maxcpu", 0) * 0.20 for x in nodes.values()), default=0),
            "memory": max((x.get("maxmem", 0) * 0.20 for x in nodes.values()), default=0),
        }
        reserve = {key: max(largest.get(key, 0), k8s_reserve[key]) for key in ("cpu", "memory")}
        recommendations = []
        for guest in guests:
            if guest.get("name") in protected_guests or guest.get("node") in protected_nodes:
                continue
            candidates = [n for n in free if n not in protected_nodes and n != guest.get("node")]
            candidates = [n for n in candidates if free[n]["cpu"] - (guest.get("maxcpu") or 0) >= reserve["cpu"] and free[n]["memory"] - (guest.get("maxmem") or 0) >= reserve["memory"]]
            if candidates:
                target = max(candidates, key=lambda n: (free[n]["memory"], free[n]["cpu"]))
                recommendations.append({"vmid": guest.get("vmid"), "name": guest.get("name"), "from": guest.get("node"), "to": target, "reason": "flexible placement"})
        return {
            "policy": {"protected_nodes": sorted(protected_nodes), "protected_guests": sorted(protected_guests), "n_plus_one": True, "kubernetes_headroom": "reserve capacity for Kubernetes growth; no automatic moves"},
            "free_allocatable": free,
            "n_plus_one_reserve": reserve,
            "recommendations": recommendations,
            "actions": "advisory only; no Proxmox write or migration operation is exposed",
        }

    def exporter_health(self):
        return {
            "scrapes": self.prom('up{job="pve_exporter_dns_sd"}'),
            "pve_up": self.dedupe(self.prom("pve_up")),
            "scrape_duration": self.prom('scrape_duration_seconds{job="pve_exporter_dns_sd"}'),
        }


TOOLS = {
    "proxmox_inventory": ("Return read-only Proxmox cluster, node, guest, and storage inventory.", {"type": "object"}),
    "capacity_current": ("Return deduplicated current Proxmox capacity metrics from Prometheus.", {"type": "object"}),
    "capacity_history": ("Return deduplicated historical capacity for a supported metric.", {"type": "object", "required": ["metric", "start", "end"], "properties": {"metric": {"type": "string"}, "start": {"type": "string"}, "end": {"type": "string"}, "step": {"type": "string", "default": "5m"}}}),
    "vm_placement": ("Return current VM/LXC placement from Proxmox.", {"type": "object"}),
    "capacity_recommendations": ("Return safe advisory placement recommendations using N+1 policy.", {"type": "object"}),
    "exporter_health": ("Return Proxmox exporter scrape and health status.", {"type": "object"}),
}


def call(capacity: Capacity, name: str, arguments: dict):
    if name == "proxmox_inventory": return capacity.inventory()
    if name == "capacity_current": return capacity.current_capacity()
    if name == "capacity_history": return capacity.history(arguments["metric"], arguments["start"], arguments["end"], arguments.get("step", "5m"))
    if name == "vm_placement": return capacity.placement()
    if name == "capacity_recommendations": return capacity.recommendations()
    if name == "exporter_health": return capacity.exporter_health()
    raise ValueError(f"unknown tool: {name}")


def main():
    capacity = Capacity()
    for line in sys.stdin:
        try:
            request = json.loads(line)
            method = request.get("method")
            result = None
            if method == "initialize":
                result = {"protocolVersion": "2024-11-05", "capabilities": {"tools": {}}, "serverInfo": {"name": "proxmox-capacity", "version": "1.0"}}
            elif method == "tools/list":
                result = {"tools": [{"name": name, "description": description, "inputSchema": schema} for name, (description, schema) in TOOLS.items()]}
            elif method == "tools/call":
                params = request.get("params", {})
                result = {"content": [{"type": "text", "text": json.dumps(call(capacity, params["name"], params.get("arguments", {})))}]}
            elif method == "notifications/initialized":
                continue
            else:
                result = {}
            print(json.dumps({"jsonrpc": "2.0", "id": request.get("id"), "result": result}), flush=True)
        except Exception as exc:
            print(json.dumps({"jsonrpc": "2.0", "id": request.get("id"), "error": {"code": -32000, "message": str(exc)}}), flush=True)


if __name__ == "__main__":
    main()
