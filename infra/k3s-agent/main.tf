resource "random_pet" "this" {
  keepers = {
    iteration = var.iteration
  }
}

resource "pihole_dns_record" "this" {
  domain = var.dns_name != null ? var.dns_name : "${random_pet.this.id}.r.ss"
  ip     = proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]
}
