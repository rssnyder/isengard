resource "digitalocean_domain" "rileysnyder_org" {
  name = "rileysnyder.org"
}

resource "digitalocean_domain" "rileysnyder_dev" {
  name = "rileysnyder.dev"
}

resource "digitalocean_record" "instance" {
  for_each = var.instances

  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = each.key
  value  = each.value.ip
}

resource "digitalocean_record" "root" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "@"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "www"
  value  = var.instances["home"].ip
}

module "metrics" {
  source = "./domain"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "metrics"
  public_ip  = var.instances["home"].ip
  private_ip = var.instances["hurley"].ip
}

resource "digitalocean_record" "s3" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "s3"
  value  = var.instances["home"].ip
}

resource "pihole_dns_record" "s3" {
  domain = "s3.${digitalocean_domain.rileysnyder_dev.name}"
  ip     = var.instances["hurley"].ip
}

resource "digitalocean_record" "pushmetrics" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "pushmetrics"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "minecraft" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "minecraft"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "files" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "files"
  value  = var.instances["home"].ip
}

resource "pihole_dns_record" "files" {
  domain = "files.${digitalocean_domain.rileysnyder_dev.name}"
  ip     = var.instances["hurley"].ip
}

resource "digitalocean_record" "requests" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "requests"
  value  = var.instances["home"].ip
}

resource "pihole_dns_record" "requests" {
  domain = "requests.${digitalocean_domain.rileysnyder_org.name}"
  ip     = var.instances["hurley"].ip
}

resource "digitalocean_record" "parson_tesla" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "parson.tesla"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "send" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "send"
  value  = var.instances["home"].ip
}

resource "pihole_dns_record" "send" {
  domain = "send.${digitalocean_domain.rileysnyder_dev.name}"
  ip     = var.instances["hurley"].ip
}

resource "digitalocean_record" "vscode" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "vscode"
  value  = var.instances["home"].ip
}

resource "pihole_dns_record" "vscode" {
  domain = "vscode.${digitalocean_domain.rileysnyder_dev.name}"
  ip     = var.instances["hurley"].ip
}

resource "digitalocean_record" "cds" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "cds"
  value  = var.instances["home"].ip
}

resource "pihole_dns_record" "cds" {
  domain = "cds.${digitalocean_domain.rileysnyder_dev.name}"
  ip     = var.instances["hurley"].ip
}

resource "digitalocean_record" "harrypottermoviepicker" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "harrypottermoviepicker"
  value  = var.instances["home"].ip
}

resource "pihole_dns_record" "harrypottermoviepicker" {
  domain = "harrypottermoviepicker.${digitalocean_domain.rileysnyder_dev.name}"
  ip     = var.instances["hurley"].ip
}

module "music" {
  source = "github.com/rssnyder/terraform-digitalocean-domain-redirect?ref=v0.1.1"

  domain    = digitalocean_domain.rileysnyder_dev.name
  subdomain = "music"
  url       = "https://music.youtube.com/browse/UCb4yhRr7Pucxv3lb_GgGeUg"
}

module "code" {
  source = "github.com/rssnyder/terraform-digitalocean-domain-redirect?ref=v0.1.1"

  domain    = digitalocean_domain.rileysnyder_dev.name
  subdomain = "code"
  url       = "https://github.com/rssnyder"
}

module "photos" {
  source = "github.com/rssnyder/terraform-digitalocean-domain-redirect?ref=v0.1.1"

  domain    = digitalocean_domain.rileysnyder_dev.name
  subdomain = "photos"
  url       = "https://github.com/rssnyder/photos"
}
