module "prometheus" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "prometheus"
  tags    = ["monitoring", "services"]
  cpu     = 2
  memory  = 2048

  node_name = "poweredge"
  iso_id    = proxmox_virtual_environment_download_file.debian_trixie.id

  size_gb = 32
}

module "plex" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "plex"
  tags    = ["plex"]

  node_name = "pve1"
  iso_id    = proxmox_virtual_environment_download_file.debian_trixie.id

  cpu     = 4
  memory  = 1024 * 8
  size_gb = 64

  ip_address = "192.168.2.100/24"
}

module "emma" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "emma"
  tags    = ["claw"]

  node_name = "poweredge"
  iso_id    = proxmox_virtual_environment_download_file.debian_trixie.id

  cpu     = 2
  memory  = 1024 * 2
  size_gb = 24

  pet = true
}

module "thehand2" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name  = "thehand"
  # dns_name = "thehand.vm"
  username = "huntermoser"
  tags     = ["claw", "hunter"]

  node_name = "pve1"
  iso_id    = proxmox_virtual_environment_download_file.debian_trixie.id

  cpu     = 2
  memory  = 1024 * 4
  size_gb = 24

  pet = true
}

# module "frigate" {
#   source = "github.com/rssnyder/terraform-proxmox-vm"

#   vm_name = "frigate"
#   tags    = ["frigate", "core"]

#   node_name = "poweredge"
#   iso_id    = proxmox_virtual_environment_download_file.debian_trixie.id

#   cpu    = 2
#   memory = 1024 * 4

#   ip_address = "192.168.2.21/24"

#   datastore_id = "frigate"
#   size_gb      = 1770

#   usb = [{
#     host = "1a6e:089a"
#     usb3 = false
#   }]

#   pet = true
# }

module "cornelius" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "cornelius"
  tags    = ["nas", "core"]

  node_name = "poweredge"
  iso_id    = proxmox_virtual_environment_download_file.debian_trixie.id

  cpu    = 6
  memory = 1024 * 6

  ip_address = "192.168.2.5/24"

  size_gb      = 64

  # mass
  #  ata-ST26000NM000C-3WE103_ZXA0D5PN
  #  ata-ST26000NM000C-3WE103_ZXA0A40J

  # red
  #  ata-WDC_WD181KFGX-68AFPN0_4BHE2GWH
  #  ata-WDC_WD181KFGX-68AFPN0_4BHDSZRH

  pet = true
}

module "polk" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "polk"

  node_name = "pve0"
  # iso_id = proxmox_virtual_environment_download_file.debian_trixie.id
}

