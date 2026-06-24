resource "proxmox_virtual_environment_vm" "control_plane" {
  for_each = { for idx, ip in var.control_plane_nodes : idx => ip }

  name            = "talos-${local.cluster_name}-cp-${each.key}"
  tags            = local.tags
  node_name       = var.proxmox_nodes[
    each.key % length(var.proxmox_nodes)
  ]
  on_boot         = true
  stop_on_destroy = true

  agent {
    enabled = true
  }

  initialization {
    datastore_id = var.root_datastore
    ip_config {
      ipv4 {
        address = "${each.value}/16"
        gateway = var.gateway_ip
      }
    }
  }


  disk {
    datastore_id = var.root_datastore
    file_id      = proxmox_download_file.talos_x86.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.control_plane_disk
  }

  cpu {
    cores = var.control_plane_cpu
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.control_plane_memory * 1024
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }
}

resource "proxmox_virtual_environment_vm" "worker" {
  for_each = { for idx, ip in var.worker_nodes : idx => ip }

  name            = "talos-${local.cluster_name}-${each.key}"
  tags            = local.tags
  node_name       = var.proxmox_nodes[
    (each.key + 1) % length(var.proxmox_nodes)
  ]
  on_boot         = true
  stop_on_destroy = true

  agent {
    enabled = true
  }

  initialization {
    datastore_id = var.root_datastore
    ip_config {
      ipv4 {
        address = "${each.value}/16"
        gateway = var.gateway_ip
      }
    }
  }

  disk {
    datastore_id = var.root_datastore
    file_id      = proxmox_download_file.talos_x86.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.worker_disk
  }

  cpu {
    cores = var.worker_cpu
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.worker_memory * 1024
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }
}
