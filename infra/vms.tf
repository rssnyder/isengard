module "prometheus" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "prometheus"
  tags = ["monitoring"]

  node_name = "poweredge"
  iso_id = proxmox_virtual_environment_download_file.debian_trixie.id

  size_gb = 512
}

module "plex" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "plex"
  tags = ["plex"]

  node_name = "pve0"
  iso_id = proxmox_virtual_environment_download_file.debian_trixie.id

  cpu = 4
  memory = 1024 * 8
  size_gb = 128
}

module "emma" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "emma"
  tags = ["ai"]

  node_name = "poweredge"
  iso_id = proxmox_virtual_environment_download_file.debian_trixie.id

  cpu = 2
  memory = 1024 * 4
  size_gb = 128
}

module "test" {
  source = "../../terraform-proxmox-vm"
}
