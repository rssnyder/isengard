resource "digitalocean_record" "this" {
  domain = var.domain
  type   = "A"
  name   = var.name
  value  = var.public_ip
}

resource "unifi_dns_record" "this" {
    name   = "${var.name}.${var.domain}"
    type   = "A"
    record = var.private_ip
}