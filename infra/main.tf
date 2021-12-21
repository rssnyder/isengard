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