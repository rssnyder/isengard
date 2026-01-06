resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "zira-red"
  node_name    = var.node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ${var.name}
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
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "${var.name}-user-data-cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  node_name = var.node_name
  name      = var.name
  tags        = concat(["terraform"], var.tags)

  disk {
    datastore_id = "data"
    import_from  = var.iso_id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  initialization {
    datastore_id = "zira-red"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  cpu {
    cores = var.cpu
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
}

resource "pihole_dns_record" "this" {
  domain = var.dns_name != null ? var.dns_name : "${var.name}.r.ss"
  ip     = proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]
}

resource "null_resource" "install_server" {

  triggers = {
    vm_id = proxmox_virtual_environment_vm.this.id
  }

  provisioner "local-exec" {
    command = <<EOF
k3sup install \
--ip ${proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]} \
--user riley \
--k3s-extra-args \
  '--disable traefik --disable servicelb --disable-cloud-controller --kubelet-arg=cloud-provider=external --kubelet-arg=node-ip=${proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]} --kubelet-arg=provider-id=proxmox://${var.cluster}/${proxmox_virtual_environment_vm.this.id}'
EOF
  }
}

resource "time_sleep" "wait_10_seconds" {
  create_duration = "10s"

  depends_on = [null_resource.install_server]
}

resource "null_resource" "install_flux_operator" {

  triggers = {
    vm_id = proxmox_virtual_environment_vm.this.id
  }

  connection {
    host = proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]
    user = "riley"
    private_key = file("/home/riley/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sL https://github.com/controlplaneio-fluxcd/flux-operator/releases/latest/download/install.yaml | sudo tee /var/lib/rancher/k3s/server/manifests/flux-operator.yaml",
    ]
  }

  depends_on = [ time_sleep.wait_10_seconds ]
}

resource "null_resource" "flux_init" {

  triggers = {
    vm_id = proxmox_virtual_environment_vm.this.id
  }

  connection {
    host = proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]
    user = "riley"
    private_key = file("/home/riley/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sL https://raw.githubusercontent.com/rssnyder/isengard/refs/heads/master/k8s/clusters/pve/flux.yaml | sudo tee /var/lib/rancher/k3s/server/manifests/flux.yaml",
    ]
  }

  depends_on = [ time_sleep.wait_10_seconds ]
}
