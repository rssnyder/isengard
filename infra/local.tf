data "http" "home" {
  url = "https://ifconfig.me/ip"
}
resource "pihole_dns_record" "files" {
  domain = "files.${var.local_domain}"
  ip     = var.instances["kate"].ip
}

resource "pihole_dns_record" "whoami" {
  domain = "whoami.${var.local_domain}"
  ip     = "192.168.253.254"
}

resource "pihole_dns_record" "desktop" {
  domain = "desktop.${var.local_domain}"
  ip     = var.instances["desktop-5cdkr1f"].ip
}

resource "pihole_dns_record" "pve0" {
  domain = "pve0.${var.local_domain}"
  ip     = var.instances["pve0"].ip
}
