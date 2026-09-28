# Proxmox capacity MCP

Read-only MCP stdio server for the Proxmox cluster and Prometheus. It uses only
Python's standard library and reads `PROXMOX_VE_API_TOKEN` from `~/.env` at
request time. The token is never returned or logged.

```sh
python3 tools/proxmox-capacity/server.py
```

Tools exposed: `proxmox_inventory`, `capacity_current`, `capacity_history`,
`vm_placement`, `capacity_recommendations`, and `exporter_health`.

Prometheus exporter data is cluster-wide and appears once per exporter. Current
results drop `instance`/`job` when deduplicating; range queries use `max by`
over identity labels because the duplicate exporters report the same values.

Recommendations are advisory only. They protect `poweredge` (Cornelius/mass)
and `plex` on `pve0`, leave N+1 capacity for the largest node, and reserve 20%
for Kubernetes growth. No Proxmox write, migration, or restart operation is
implemented.

## Grafana

`monitoring/grafana/dashboards/proxmox-capacity.json` is an importable dashboard
for the existing Prometheus datasource. Import it through Grafana's dashboard
UI or place it in the Grafana dashboard provisioning directory used by the
host; it contains no credentials.

## Smoke tests

```sh
python3 -m unittest discover -s tools/proxmox-capacity -p 'test_*.py'
```

Live smoke tests should use the runtime environment and only GET requests:
check Proxmox `/cluster/status`, Prometheus `/-/ready`, and Prometheus
`/api/v1/query?query=up`.
