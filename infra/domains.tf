resource "digitalocean_domain" "rileysnyder_org" {
  name = "rileysnyder.org"
}

resource "digitalocean_record" "instance" {
  for-each = var.instances

  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = each.key
  value  = each.value.ip
}

resource "digitalocean_record" "lighthouse" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "lighthouse"
  value  = var.instances["oc0"].ip
}

resource "digitalocean_record" "metrics" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "metrics"
  value  = var.instances["oc0"].ip
}

resource "digitalocean_record" "minecraft" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "minecraft"
  value  = var.instances["oc0"].ip
}

resource "digitalocean_record" "files" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "files"
  value  = var.instances["oc0"].ip
}

resource "digitalocean_record" "code" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "code"
  value  = var.instances["oc0"].ip
}

resource "digitalocean_record" "qbittorrent" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "qbittorrent"
  value  = var.instances["oc0"].ip
}

resource "digitalocean_record" "public" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "public"
  value  = var.instances["oc0"].ip
}

resource "digitalocean_record" "wubby" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "wubby"
  value  = var.instances["wubby"].ip
}

resource "digitalocean_record" "tracker" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "tracker"
  value  = var.instances["wubby"].ip
}