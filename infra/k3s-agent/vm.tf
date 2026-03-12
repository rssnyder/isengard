resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = var.snippet_datastore_id
  node_name    = var.node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ${random_pet.this.id}
    timezone: America/Chicago
    users:
      - default
      - name: riley
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(var.public_key)}
        sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - qemu-guest-agent
      - open-iscsi
      - nfs-kernel-server
      - lvm2
    write_files:
      - path: /etc/sysctl.d/99-inotify.conf
        content: |
          fs.inotify.max_user_watches=1048576
          fs.inotify.max_user_instances=8192
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - sysctl --system
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "${random_pet.this.id}-user-data-cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  node_name = var.node_name
  name      = random_pet.this.id
  tags      = concat(["terraform"], var.tags)

  disk {
    datastore_id = "data"
    import_from  = var.iso_id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  initialization {
    datastore_id = var.snippet_datastore_id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  cpu {
    cores = var.cpu
    type         = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.memory
  }

  network_device {
    bridge = "vmbr0"
  }

  agent {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [disk[0].import_from, initialization[0].user_data_file_id]
  }
}