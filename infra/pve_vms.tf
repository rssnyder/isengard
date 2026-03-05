module "prometheus" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "prometheus"
  tags    = ["monitoring", "services", "core"]
  cpu     = 2
  memory  = 2048

  node_name = "poweredge"
  iso_id    = proxmox_virtual_environment_download_file.debian_trixie.id

  size_gb = 512
}

module "plex" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "plex"
  tags    = ["plex", "core"]

  node_name = "pve0"
  iso_id    = proxmox_virtual_environment_download_file.debian_trixie.id

  cpu     = 4
  memory  = 1024 * 8
  size_gb = 128
}

module "emma" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "emma"
  tags    = ["ai"]

  node_name = "poweredge"
  iso_id    = proxmox_virtual_environment_download_file.debian_trixie.id

  cpu     = 2
  memory  = 1024 * 4
  size_gb = 128

  pet = true
}

module "steve" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "steve"
  tags    = ["ai"]

  node_name = "pve0"
  iso_id    = proxmox_virtual_environment_download_file.debian_trixie.id

  cpu     = 2
  memory  = 1024 * 4
  size_gb = 64
}

module "thehand" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name  = "thehand"
  dns_name = "thehand.vm"
  username = "huntermoser"
  tags     = ["ai", "hunter"]

  node_name = "poweredge"
  iso_id    = proxmox_virtual_environment_download_file.debian_trixie.id

  cpu     = 2
  memory  = 1024 * 4
  size_gb = 512

  pet = true
}

module "frigate" {
  source = "github.com/rssnyder/terraform-proxmox-vm?ref=feat/static-ip"

  vm_name = "frigate"
  tags    = ["frigate", "core"]

  node_name = "poweredge"
  iso_id    = proxmox_virtual_environment_download_file.debian_trixie.id

  cpu    = 2
  memory = 1024 * 4

  ip_address = "192.168.2.21/24"

  datastore_id = "frigate"
  size_gb      = 1770

  usb = [{
    host = "1a6e:089a"
    usb3 = false
  }]

  pet = true
}

# module "jeff" {
#   source = "../../terraform-proxmox-vm"

#   vm_name = "jeff"
#   username = "jeff"
#   tags = ["jeff"]

#   node_name = "poweredge"
#   iso_id = proxmox_virtual_environment_download_file.debian_trixie.id

#   cpu = 1
#   memory = 1024

#   ttyd_password = "iuhwdfh4378fy43fuhref9g"
# }

