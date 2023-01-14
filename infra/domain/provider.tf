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