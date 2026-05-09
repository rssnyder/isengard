resource "unifi_dns_record" "this" {
  name   = var.dns_name != null ? var.dns_name : "${var.name}.r.ss"
  type   = "A"
  record = proxmox_virtual_environment_vm.this.ipv4_addresses[1][0]
}

resource "unifi_dns_record" "prometheus_srv" {
  name     = "_prometheus._tcp.r.ss"
  type     = "SRV"
  record   = var.dns_name != null ? var.dns_name : "${var.name}.r.ss"
  port     = 9100
  priority = 1
  weight   = 0
}
