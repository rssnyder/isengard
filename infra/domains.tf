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

# module "s3" {
#   source = "./domain"

#   domain     = digitalocean_domain.rileysnyder_dev.name
#   name       = "s3"
#   public_ip  = var.instances["home"].ip
#   private_ip = var.instances["hurley"].ip
# }

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

# module "files" {
#   source = "./domain"

#   domain     = digitalocean_domain.rileysnyder_dev.name
#   name       = "files"
#   public_ip  = var.instances["home"].ip
#   private_ip = var.instances["hurley"].ip
# }

# module "requests" {
#   source = "./domain"

#   domain     = digitalocean_domain.rileysnyder_dev.name
#   name       = "requests"
#   public_ip  = var.instances["home"].ip
#   private_ip = var.instances["hurley"].ip
# }

resource "digitalocean_record" "parson_tesla" {
  domain = digitalocean_domain.rileysnyder_org.name
  type   = "A"
  name   = "parson.tesla"
  value  = var.instances["home"].ip
}

# module "send" {
#   source = "./domain"

#   domain     = digitalocean_domain.rileysnyder_dev.name
#   name       = "send"
#   public_ip  = var.instances["home"].ip
#   private_ip = var.instances["hurley"].ip
# }

# module "vscode" {
#   source = "./domain"

#   domain     = digitalocean_domain.rileysnyder_dev.name
#   name       = "vscode"
#   public_ip  = var.instances["home"].ip
#   private_ip = var.instances["hurley"].ip
# }

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
