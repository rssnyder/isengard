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
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "@"
  value  = each.key
  ttl = 1800
}

resource "digitalocean_record" "www" {
  for_each = toset(var.github_pages)
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "www"
  value  = each.key
  ttl = 1800
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

module "registry" {
  source = "github.com/rssnyder/isengard//infra/external-internal-dns"

  domain     = digitalocean_domain.rileysnyder_dev.name
  name       = "registry"
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

resource "digitalocean_record" "star-app" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "*.app"
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

resource "digitalocean_record" "auth" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "auth"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "books" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "books"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "s3_tx" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "s3.tx"
  value  = var.instances["tx"].ip
}

resource "digitalocean_record" "nginx_tx" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "nginx.tx"
  value  = var.instances["tx"].ip
}

resource "digitalocean_record" "azurestopping" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "azurestopping"
  value  = "20.9.25.180"
}

resource "digitalocean_record" "whoami" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "whoami"
  value  = var.instances["oca0"].ip
}

resource "digitalocean_record" "star-oc" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "*.oc"
  value  = var.instances["oca0"].ip
}

resource "digitalocean_record" "star-oc-dr" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "*.oc-dr"
  value  = var.instances["oca8"].ip
}

resource "digitalocean_record" "harness" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "harness"
  value  = var.instances["home"].ip
}

resource "digitalocean_record" "awslb-harness" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "CNAME"
  name   = "*.awslb.harness"
  value  = "snyder-lab-alb-2080643085.us-west-2.elb.amazonaws.com."
}

resource "digitalocean_record" "star-awsproxy-harness" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "*.awsproxy.harness"
  value  = "52.36.176.96"
}

resource "digitalocean_record" "star-azureproxy-harness" {
  domain = digitalocean_domain.rileysnyder_dev.name
  type   = "A"
  name   = "*.azureproxy.harness"
  value  = "13.89.188.232"
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
