terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    pihole = {
      source = "ryanwholey/pihole"
    }
    harness = {
      source = "harness/harness"
    }
  }
}

provider "digitalocean" {}

provider "pihole" {
  url = "http://192.168.0.3:8888"
}

provider "harness" {
  endpoint   = "https://app.harness.io/gateway"
  account_id = "-N_5zBuvRm2gzVAaNZ64lQ"
}