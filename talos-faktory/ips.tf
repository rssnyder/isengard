# allocate unused ips from the static zone (outside the dhcp pool) when
# explicit node ips are not given
resource "localdhcp_ip" "control_plane" {
  count = var.control_plane_nodes == null ? var.control_plane_count : 0

  range_start = var.ip_range_start
  range_end   = var.ip_range_end
}

resource "localdhcp_ip" "worker" {
  count = var.worker_nodes == null ? var.worker_count : 0

  range_start = var.ip_range_start
  range_end   = var.ip_range_end
}

locals {
  control_plane_nodes = var.control_plane_nodes != null ? var.control_plane_nodes : localdhcp_ip.control_plane[*].ip
  worker_nodes        = var.worker_nodes != null ? var.worker_nodes : localdhcp_ip.worker[*].ip
}
