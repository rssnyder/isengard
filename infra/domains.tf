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
  for_each = toset(var.github_pages)
  domain   = digitalocean_domain.rileysnyder_dev.name
  type     = "A"
  name     = "@"
  value    = each.key
  ttl      = 1800
}

resource "digitalocean_record" "www" {
  for_each = toset(var.github_pages)
  domain   = digitalocean_domain.rileysnyder_dev.name
  type     = "A"
  name     = "www"
  value    = each.key
  ttl      = 1800
}

// services

module "hurley-dns-entries" {
  for_each = toset([
    "metrics",
    "s3",
    "pushmetrics",
    "files",
    "filez",
    "requests",
    "vscode",
    "keys",
    "dash",
    "plex",
    "vhsarchive",
    "bothwellarchive",
    "cds",
    "auth",
    "books",
    "harrypottermoviepicker",
    "photos",
    "home"
  ])
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = each.value
  public_ip  = chomp(data.http.home.response_body)
  private_ip = var.instances["hurley"].ip
}

resource "digitalocean_record" "home-star" {
  for_each = toset([
    "*.k8s",
    "*.app",
    "*.pve",
  ])
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = each.value
  value  = chomp(data.http.home.response_body)
}

resource "digitalocean_record" "texas" {
  for_each = toset([
    "s3.tx",
    "nginx.tx",
    "b4wtest",
  ])
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = each.value
  value  = var.instances["tx"].ip
}

resource "digitalocean_record" "azurestopping" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "azurestopping"
  value  = "20.9.25.180"
}

resource "digitalocean_record" "txmc" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "txmc"
  value  = var.instances["oca8"].ip
}

resource "digitalocean_record" "oca0" {
  for_each = toset([
    "whoami",
    "*.oc",
    "*.b4wtest"
  ])
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = each.value
  value  = var.instances["oca0"].ip
}

// github pages

# resource "digitalocean_record" "photos" {
#   domain = digitalocean_domain.rileysnyder_dev.name
#   type   = "CNAME"
#   name   = "photos"
#   value  = "rssnyder.github.io."
# }

//work

resource "digitalocean_record" "isehrns" {
  for_each = toset(["ns-1627.awsdns-11.co.uk.", "ns-418.awsdns-52.com.", "ns-1167.awsdns-17.org.", "ns-597.awsdns-10.net."])

  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "NS"
  name   = "isehrns"
  value  = each.key
}

// redirects

module "music" {
  source = "github.com/rssnyder/terraform-digitalocean-domain-redirect?ref=v0.2.0"

  domain    = digitalocean_domain.rileysnyder_dev.name
  subdomain = "music"
  url       = "https://music.youtube.com/browse/UCb4yhRr7Pucxv3lb_GgGeUg"
  permanent = true
}

module "code" {
  source = "github.com/rssnyder/terraform-digitalocean-domain-redirect?ref=v0.2.0"

  domain    = digitalocean_domain.rileysnyder_dev.name
  subdomain = "code"
  url       = "https://github.com/rssnyder"
  permanent = true
}
