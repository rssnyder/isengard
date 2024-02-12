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

variable "minio_texas_password" {
  type = string
  sensitive = true
}

provider minio {
  alias = "texas"
  minio_server = "192.168.0.34:9000"
  minio_user = "admin"
  minio_password = var.minio_texas_password
  minio_ssl = false
}

variable "minio_k8s_password" {
  type = string
  sensitive = true
}

provider minio {
  alias = "k8s"
  minio_server = "minio.r.ss"
  minio_user = "admin"
  minio_password = var.minio_k8s_password
  minio_ssl = false
}
