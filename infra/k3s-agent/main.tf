resource "random_pet" "this" {
  keepers = {
    iteration = var.iteration
  }
}

resource "unifi_dns_record" "this" {
  name   = var.dns_name != null ? var.dns_name : "${random_pet.this.id}.r.ss"
  type   = "A"
  record = proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]
}

resource "unifi_dns_record" "prometheus_srv" {
  name     = "_prometheus._tcp.r.ss"
  type     = "SRV"
  record   = var.dns_name != null ? var.dns_name : "${random_pet.this.id}.r.ss"
  port     = 9100
  priority = 1
  weight   = 0
}
