resource "digitalocean_domain" "rileysnyder_org" {
  name = "rileysnyder.org"
}

resource "digitalocean_record" "instance" {
  for_each = var.instances

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
  value  = var.instances["kate"].ip
}

resource "digitalocean_record" "pushmetrics" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "pushmetrics"
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

resource "digitalocean_record" "vscode" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "vscode"
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

resource "digitalocean_record" "network" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "network"
  value  = var.instances["oc0"].ip
}

resource "digitalocean_record" "requests" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "requests"
  value  = var.instances["oc0"].ip
}

resource "digitalocean_record" "github_pages" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "TXT"
  name   = "_github-pages-challenge-rssnyder"
  value  = "8169904a00a3d52c5118bf5743ca2a"
}

module "music" {
  source = "github.com/rssnyder/digitalocean_domain_redirect?ref=v0.1.0"

  domain    = "rileysnyder.org"
  subdomain = "music"
  url       = "https://music.youtube.com/browse/UCb4yhRr7Pucxv3lb_GgGeUg"
}

module "code" {
  source = "github.com/rssnyder/digitalocean_domain_redirect?ref=v0.1.0"

  domain    = "rileysnyder.org"
  subdomain = "code"
  url       = "https://github.com/rssnyder"
}
