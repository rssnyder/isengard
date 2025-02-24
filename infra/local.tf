resource "pihole_dns_record" "files" {
  domain = "files.${var.local_domain}"
  ip     = var.instances["t480-0"].ip
}

resource "pihole_dns_record" "whoami" {
  domain = "whoami.${var.local_domain}"
  ip     = "192.168.253.254"
}

resource "pihole_dns_record" "desktop" {
  domain = "desktop.${var.local_domain}"
  ip     = var.instances["desktop-5cdkr1f"].ip
}