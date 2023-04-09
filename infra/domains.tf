resource "digitalocean_domain" "rileysnyder_org" {
  name = "rileysnyder.org"
}

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

module "requests" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_org.name
  name       = "requests"
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

module "send" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "send"
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

module "registry" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "registry"
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

resource "digitalocean_record" "parson_tesla" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "parson.tesla"
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

resource "digitalocean_record" "bbb" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "bbb"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "alexsnyder_root" {
  domain = digitalocean_domain.alexsnyder_net.name
  type   = "A"
  name   = "@"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "alexsnyder_www" {
  domain = digitalocean_domain.alexsnyder_net.name
  type   = "A"
  name   = "www"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "pages" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "TXT"
  name   = "_github-pages-challenge-rssnyder"
  value  = "5affa6f4d230839d19855811ef2712"
}

resource "digitalocean_record" "vhs" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "CNAME"
  name   = "vhs"
  value  = "rssnyder.github.io."
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

module "photos" {
  source = "github.com/rssnyder/terraform-digitalocean-domain-redirect?ref=v0.2.0"

  domain    = digitalocean_domain.rileysnyder_dev.name
  subdomain = "photos"
  path      = "/local"
  url       = "https://github.com/rssnyder/photos"
}
