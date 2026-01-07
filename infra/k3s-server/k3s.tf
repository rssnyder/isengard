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
  '--disable traefik --disable servicelb --embedded-registry --disable-cloud-controller --kubelet-arg=cloud-provider=external --kubelet-arg=node-ip=${proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]} --kubelet-arg=provider-id=proxmox://${var.cluster}/${proxmox_virtual_environment_vm.this.id}'
EOF
  }
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"

  depends_on = [null_resource.install_server]
}

resource "null_resource" "node_ready" {

  triggers = {
    vm_id = proxmox_virtual_environment_vm.this.id
  }

  connection {
    host        = proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]
    user        = "riley"
    private_key = file("/home/riley/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo kubectl taint nodes ${var.name} node.cloudprovider.kubernetes.io/uninitialized=true:NoSchedule-",
    ]
  }

  depends_on = [time_sleep.wait_60_seconds]
}

resource "null_resource" "registry_mirror" {

  triggers = {
    vm_id = proxmox_virtual_environment_vm.this.id
  }

  connection {
    host        = proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]
    user        = "riley"
    private_key = file("/home/riley/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'mirrors:\n  \"*\":' | sudo tee /etc/rancher/k3s/registries.yaml",
    ]
  }

  depends_on = [time_sleep.wait_60_seconds]
}

resource "null_resource" "install_flux_operator" {

  triggers = {
    vm_id = proxmox_virtual_environment_vm.this.id
  }

  connection {
    host        = proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]
    user        = "riley"
    private_key = file("/home/riley/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sL https://github.com/controlplaneio-fluxcd/flux-operator/releases/latest/download/install.yaml | sudo tee /var/lib/rancher/k3s/server/manifests/flux-operator.yaml",
    ]
  }

  depends_on = [time_sleep.wait_60_seconds]
}

resource "null_resource" "flux_init" {

  triggers = {
    vm_id = proxmox_virtual_environment_vm.this.id
  }

  connection {
    host        = proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]
    user        = "riley"
    private_key = file("/home/riley/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sL https://raw.githubusercontent.com/rssnyder/isengard/refs/heads/master/k8s/clusters/pve/flux.yaml | sudo tee /var/lib/rancher/k3s/server/manifests/flux.yaml",
    ]
  }

  depends_on = [time_sleep.wait_60_seconds]
}
