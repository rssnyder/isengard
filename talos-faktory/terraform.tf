terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
    talos = {
        source = "siderolabs/talos"
    }
  }
  backend "s3" {
    bucket                      = "isengard"
    key                         = "talos.tfstate"
    endpoint                    = "https://s3.rileysnyder.dev"
    region                      = "main"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }
}


provider "proxmox" {
  endpoint = "https://192.168.2.69:8006"
  insecure = true

  ssh {
    agent       = false
    username    = "root"
    private_key = file("~/.ssh/id_rsa")
  }
}
