# verify against `pveam update && pveam available` on a node before applying —
# proxmox rotates point releases and a stale filename 404s the download.
resource "proxmox_download_file" "debian_trixie_lxc" {
  content_type = "vztmpl"
  datastore_id = "baelor"
  node_name    = data.proxmox_virtual_environment_nodes.this.names[0]
  url          = "http://download.proxmox.com/images/system/debian-13-standard_13.1-2_amd64.tar.zst"
  overwrite    = true
}

# one allocation per node, pinned in state on first apply — same static
# zone (below the .128 dhcp_start in local.tf) as the talos-faktory usage
# this provider was built for.
resource "localdhcp_ip" "pve_exporter" {
  for_each = toset(data.proxmox_virtual_environment_nodes.this.names)

  range_start = "192.168.2.32"
  range_end   = "192.168.2.127"
}

# one exporter ct per cluster node. prometheus-pve-exporter queries the
# cluster api so any single instance can see every node's stats, but running
# one per host means losing a node doesn't blind that host's scrape target,
# same reasoning as the per-host node_exporter fleet.
module "pve_exporter" {
  for_each = toset(data.proxmox_virtual_environment_nodes.this.names)
  source   = "./pve-exporter"

  node_name = each.key
  hostname  = "pve-exporter-${each.key}"
  # handed out via unifi dhcp fixed-ip, not configured statically inside the
  # guest — see localdhcp_ip.pve_exporter for how the address was picked.
  ip_address = localdhcp_ip.pve_exporter[each.key].ip
  network_id = unifi_network.default.id
  public_key = data.local_file.ssh_public_key.content

  template_file_id = proxmox_download_file.debian_trixie_lxc.id
}

# PVEAuditor is a built-in proxmox role (read-only cluster/vm/node status) —
# plenty for the exporter, no custom role needed like ccm/csi in pve_k3s.tf.
resource "proxmox_virtual_environment_user" "prometheus" {
  acl {
    path      = "/"
    propagate = true
    role_id   = "PVEAuditor"
  }

  comment = "prometheus-pve-exporter"
  user_id = "prometheus@pve"
}

resource "proxmox_user_token" "prometheus" {
  comment    = "prometheus-pve-exporter"
  token_name = "exporter"
  user_id    = proxmox_virtual_environment_user.prometheus.user_id
}

resource "proxmox_acl" "prometheus" {
  token_id = proxmox_user_token.prometheus.id
  role_id  = "PVEAuditor"

  path      = "/"
  propagate = true
}

# rendered pve.yml, ready for the ansible role to drop onto each ct verbatim.
resource "vault_kv_secret" "pve_exporter" {
  path = "${vault_mount.pve.path}/prometheus-pve-exporter"
  data_json = jsonencode({
    "pve.yml" = <<EOF
default:
    user: ${proxmox_virtual_environment_user.prometheus.user_id}
    token_name: "${proxmox_user_token.prometheus.token_name}"
    token_value: "${split("=", proxmox_user_token.prometheus.value)[1]}"
    verify_ssl: false
EOF
  })
}

# feed the ansible "hypervisor" group / dynamic inventory: one exporter ct
# per proxmox host, IP + hostname + the account the ssh key was installed on.
output "pve_exporter_hosts" {
  value = {
    for k, m in module.pve_exporter : k => {
      ip       = m.ip_address
      hostname = m.hostname
      user     = m.username
    }
  }
}
