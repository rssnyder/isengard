locals {
  private_ipv4 = length(proxmox_virtual_environment_vm.this.ipv4_addresses) > 1 ? proxmox_virtual_environment_vm.this.ipv4_addresses[1][0] : null
}

output "vm_ipv4_address" {
  value = local.private_ipv4
}
