terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
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
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc03"
    }
    http = {
      source = "hashicorp/http"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "isengard"
    key    = "terraform.tfstate"
    # endpoint                    = "https://s3.rileysnyder.dev"
    endpoint                    = "http://192.168.2.2:9000"
    region                      = "main"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }
}

provider "digitalocean" {}

provider "pihole" {
  url = "http://192.168.2.2:8888"
}

provider "minio" {
  # minio_server = "s3.rileysnyder.dev"
  minio_server = "192.168.2.2:9000"
  minio_ssl    = false
}

variable "minio_texas_password" {
  type      = string
  sensitive = true
}

provider "minio" {
  alias          = "texas"
  minio_server   = "192.168.0.34:9000"
  minio_user     = "admin"
  minio_password = var.minio_texas_password
  minio_ssl      = false
}

variable "minio_k8s_password" {
  type      = string
  sensitive = true
}

provider "minio" {
  alias          = "k8s"
  minio_server   = "minio.r.ss"
  minio_user     = "admin"
  minio_password = var.minio_k8s_password
  minio_ssl      = false
}

provider "proxmox" {
  pm_api_url                  = "https://192.168.2.70:8006/api2/json"
  pm_tls_insecure             = true
  pm_minimum_permission_check = false
}
