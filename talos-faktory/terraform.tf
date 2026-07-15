terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
    talos = {
      source = "siderolabs/talos"
    }
    unifi = {
      source  = "filipowm/unifi"
      version = "~> 1.0.0"
    }
  }
}
