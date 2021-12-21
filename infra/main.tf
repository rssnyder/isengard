resource "digitalocean_domain" "rileysnyder_org" {
  name = "rileysnyder.org"
}

resource "digitalocean_record" "lighthouse" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "lighthouse"
  value  = var.oc0
}

resource "digitalocean_record" "metrics" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "metrics"
  value  = var.oc0
}

resource "digitalocean_record" "minecraft" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "minecraft"
  value  = var.oc0
}

resource "digitalocean_record" "files" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "files"
  value  = var.oc0
}

resource "digitalocean_record" "code" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "code"
  value  = var.oc0
}

resource "digitalocean_record" "qbittorrent" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "qbittorrent"
  value  = var.oc0
}

resource "digitalocean_record" "public" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "public"
  value  = var.oc0
}

resource "digitalocean_record" "wubby" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "wubby"
  value  = var.wubby
}

resource "digitalocean_record" "tracker" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "tracker"
  value  = var.wubby
}