resource "null_resource" "join_agent" {

  triggers = {
    vm_id = proxmox_virtual_environment_vm.this.id
  }

  provisioner "local-exec" {
    command = <<EOF
k3sup join \
--ip ${proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]} --server-ip ${var.server_ip} \
--user riley --server-user riley \
--k3s-extra-args \
  '--kubelet-arg=cloud-provider=external --kubelet-arg=node-ip=${proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]} --kubelet-arg=provider-id=proxmox://${var.cluster}/${proxmox_virtual_environment_vm.this.id}'
EOF
  }
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"

  depends_on = [null_resource.join_agent]
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
      "sudo mkdir -p /etc/rancher/k3s && echo 'mirrors:\n  \"*\":' | sudo tee /etc/rancher/k3s/registries.yaml",
    ]
  }

  depends_on = [time_sleep.wait_60_seconds]
}

# resource "null_resource" "node_ready" {

#   triggers = {
#     vm_id = proxmox_virtual_environment_vm.this.id
#   }

#   connection {
#     host        = proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]
#     user        = "riley"
#     private_key = file("/home/riley/.ssh/id_rsa")
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo kubectl taint nodes ${random_pet.this.id} node.cloudprovider.kubernetes.io/uninitialized=true:NoSchedule-",
#     ]
#   }

#   depends_on = [time_sleep.wait_10_seconds]
# }