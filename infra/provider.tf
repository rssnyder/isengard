terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
    }
    pihole = {
      source = "ryanwholey/pihole"
    }
    harness = {
      source = "harness/harness"
    }
    minio = {
      source = "aminueza/minio"
    }
  }
  backend "s3" {
    bucket                      = "isengard"
    key                         = "terraform.tfstate"
    endpoint                    = "https://s3.rileysnyder.dev"
    region                      = "main"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}

provider "digitalocean" {}

provider "pihole" {
  url = "http://192.168.0.3:8888"
}


provider minio {}