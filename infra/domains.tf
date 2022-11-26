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

resource "digitalocean_record" "root" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "@"
  value  = var.instances["hurley"].ip
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "www"
  value  = var.instances["hurley"].ip
}

resource "digitalocean_record" "metrics" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "metrics"
  value  = var.instances["hurley"].ip
}

resource "pihole_dns_record" "metrics" {
  domain = "metrics.${digitalocean_domain.rileysnyder_org.name}"
  ip     = var.instances["hurley-local"].ip
}

resource "digitalocean_record" "s3" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "s3"
  value  = var.instances["hurley"].ip
}

resource "pihole_dns_record" "s3" {
  domain = "s3.${digitalocean_domain.rileysnyder_org.name}"
  ip     = var.instances["hurley-local"].ip
}

resource "digitalocean_record" "pushmetrics" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "pushmetrics"
  value  = var.instances["hurley"].ip
}

resource "digitalocean_record" "minecraft" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "minecraft"
  value  = var.instances["hurley"].ip
}

resource "digitalocean_record" "files" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "files"
  value  = var.instances["hurley"].ip
}

resource "pihole_dns_record" "files" {
  domain = "files.${digitalocean_domain.rileysnyder_org.name}"
  ip     = var.instances["hurley-local"].ip
}

resource "digitalocean_record" "requests" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "requests"
  value  = var.instances["hurley"].ip
}

resource "pihole_dns_record" "requests" {
  domain = "requests.${digitalocean_domain.rileysnyder_org.name}"
  ip     = var.instances["hurley-local"].ip
}

resource "digitalocean_record" "parson_tesla" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "parson.tesla"
  value  = var.instances["hurley"].ip
}

resource "digitalocean_record" "send" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "send"
  value  = var.instances["hurley"].ip
}

resource "pihole_dns_record" "send" {
  domain = "send.${digitalocean_domain.rileysnyder_org.name}"
  ip     = var.instances["hurley-local"].ip
}

resource "digitalocean_record" "cameras" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "cameras"
  value  = var.instances["hurley"].ip
}

resource "pihole_dns_record" "cameras" {
  domain = "monitor.${digitalocean_domain.rileysnyder_org.name}"
  ip     = var.instances["hurley-local"].ip
}

resource "digitalocean_record" "eraser" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "eraser"
  value  = var.instances["hurley"].ip
}

resource "pihole_dns_record" "eraser" {
  domain = "eraser.${digitalocean_domain.rileysnyder_org.name}"
  ip     = var.instances["kate"].ip
}

resource "digitalocean_record" "notify" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "notify"
  value  = var.instances["hurley"].ip
}

resource "pihole_dns_record" "notify" {
  domain = "notify.${digitalocean_domain.rileysnyder_org.name}"
  ip     = var.instances["hurley-local"].ip
}

resource "digitalocean_record" "vscode" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "vscode"
  value  = var.instances["hurley"].ip
}

resource "pihole_dns_record" "vscode" {
  domain = "vscode.${digitalocean_domain.rileysnyder_org.name}"
  ip     = var.instances["hurley-local"].ip
}

# resource "digitalocean_record" "github_pages" {
#   domain = digitalocean_domain.rileysnyder_org.name
#   type   = "TXT"
#   name   = "_github-pages-challenge-rssnyder"
#   value  = "8169904a00a3d52c5118bf5743ca2a"
# }

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

module "photos" {
  source = "github.com/rssnyder/digitalocean_domain_redirect?ref=v0.1.0"

  domain    = "rileysnyder.org"
  subdomain = "photos"
  url       = "https://github.com/rssnyder/photos"
}

module "bots" {
  source = "github.com/rssnyder/digitalocean_domain_redirect?ref=v0.1.0"

  domain    = "rileysnyder.org"
  subdomain = "bots"
  url       = "https://github.com/rssnyder/discord-stock-ticker"
}

resource "pihole_dns_record" "kate" {
  domain = "kate.${digitalocean_domain.rileysnyder_org.name}"
  ip     = var.instances["kate"].ip
}

resource "pihole_dns_record" "hurley" {
  domain = "hurley.${digitalocean_domain.rileysnyder_org.name}"
  ip     = var.instances["hurley-local"].ip
}