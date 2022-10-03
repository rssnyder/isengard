terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    pihole = {
      source = "ryanwholey/pihole"
    }
  }
}

provider "digitalocean" {}

provider "pihole" {
  url      = "http://192.168.0.3:8888"
}