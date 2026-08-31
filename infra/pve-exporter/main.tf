# lxc only sets a password/keys on root; there's no separate account to
# create, so this exists purely to satisfy proxmox's "must set something"
# requirement for user_account without hardcoding a plaintext password.
resource "random_password" "this" {
  length  = 24
  special = false
}

locals {
  # deterministic + locally-administered (02 prefix) so it's stable across
  # recreates and the unifi fixed-ip reservation keeps pointing at the same
  # container instead of drifting to whatever proxmox rolls next.
  mac_address = "02:${join(":", [for i in range(5) : substr(md5(var.hostname), i * 2, 2)])}"
}

resource "proxmox_virtual_environment_container" "this" {
  node_name    = var.node_name
  vm_id        = var.vm_id
  tags         = concat(["terraform"], var.tags)
  started      = true
  unprivileged = true

  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys     = [trimspace(var.public_key)]
      password = random_password.this.result
    }
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.size_gb
  }

  cpu {
    cores = var.cpu
  }

  memory {
    dedicated = var.memory
  }

  network_interface {
    name        = "eth0"
    bridge      = var.bridge
    mac_address = local.mac_address
  }

  operating_system {
    template_file_id = var.template_file_id
    type             = "debian"
  }
}

# same pattern as var.instances in local.tf: dhcp handles the lease, unifi
# just always hands this mac the same address and registers the a record.
resource "unifi_user" "this" {
  mac  = local.mac_address
  name = var.hostname
  note = "by isengard"

  fixed_ip         = var.ip_address
  local_dns_record = "${var.hostname}.r.ss"
  network_id       = var.network_id
}

resource "unifi_dns_record" "prometheus_srv" {
  name     = "_prometheus._tcp.r.ss"
  type     = "SRV"
  record   = "${var.hostname}.r.ss"
  port     = var.prometheus_port
  priority = 1
  weight   = 0
}
