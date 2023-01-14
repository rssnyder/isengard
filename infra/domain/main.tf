resource "digitalocean_record" "this" {
  domain = var.domain
  type   = "A"
  name   = var.name
  value  = var.public_ip
}

resource "pihole_dns_record" "this" {
  domain = "${var.name}.${var.domain}"
  ip     = var.private_ip
}