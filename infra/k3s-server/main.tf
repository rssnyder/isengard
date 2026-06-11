resource "unifi_dns_record" "this" {
  count = local.private_ipv4 != null ? 1 : 0
  name   = var.dns_name != null ? var.dns_name : "${var.name}.r.ss"
  type   = "A"
  record = local.private_ipv4
}

resource "unifi_dns_record" "prometheus_srv" {
  name     = "_prometheus._tcp.r.ss"
  type     = "SRV"
  record   = var.dns_name != null ? var.dns_name : "${var.name}.r.ss"
  port     = 9100
  priority = 1
  weight   = 0
}
