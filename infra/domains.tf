resource "digitalocean_domain" "rileysnyder_dev" {
  name = "rileysnyder.dev"
}

resource "digitalocean_domain" "alexsnyder_net" {
  name = "alexsnyder.net"
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

// services

module "metrics" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "metrics"
  public_ip  = var.instances["home"].ip
  private_ip = var.instances["hurley"].ip
}

module "s3" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "s3"
  public_ip  = var.instances["home"].ip
  private_ip = var.instances["hurley"].ip
}

module "pushmetrics" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "pushmetrics"
  public_ip  = var.instances["home"].ip
  private_ip = var.instances["hurley"].ip
}

module "files" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "files"
  public_ip  = var.instances["home"].ip
  private_ip = var.instances["hurley"].ip
}

module "requests_dev" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "requests"
  public_ip  = var.instances["home"].ip
  private_ip = var.instances["hurley"].ip
}

module "vscode" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "vscode"
  public_ip  = var.instances["home"].ip
  private_ip = var.instances["hurley"].ip
}

module "keys" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "keys"
  public_ip  = var.instances["home"].ip
  private_ip = var.instances["hurley"].ip
}

module "dash" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "dash"
  public_ip  = var.instances["home"].ip
  private_ip = var.instances["hurley"].ip
}

module "plex" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "plex"
  public_ip  = var.instances["home"].ip
  private_ip = var.instances["hurley"].ip
}

module "vhsarchive" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "vhsarchive"
  public_ip  = var.instances["home"].ip
  private_ip = var.instances["hurley"].ip
}

module "bothwellarchive" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "bothwellarchive"
  public_ip  = var.instances["home"].ip
  private_ip = var.instances["hurley"].ip
}

resource "digitalocean_record" "star-k8s" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "*.k8s"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "star-media" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "*.media"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "cds" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "cds"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "harrypottermoviepicker" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "harrypottermoviepicker"
  value  = var.instances["home"].ip
}

// github pages

# resource "digitalocean_record" "photos" {
#   domain = digitalocean_domain.rileysnyder_dev.name
#   type   = "CNAME"
#   name   = "photos"
#   value  = "rssnyder.github.io."
# }

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

// local only

resource "pihole_dns_record" "cluster_local" {
  domain = "cluster.local"
  ip     = var.instances["charlie"].ip
}
