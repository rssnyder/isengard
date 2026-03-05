terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    pihole = {
      source = "ryanwholey/pihole"
    }
    unifi = {
      source  = "filipowm/unifi"
      version = "~> 1.0"
    }
  }
}