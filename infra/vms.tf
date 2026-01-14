module "prometheus" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "prometheus"
  tags = ["monitoring"]

  node_name = "poweredge"
  iso_id = proxmox_virtual_environment_download_file.debian_trixie.id

  size_gb = 512
}

module "test" {
  source = "../../terraform-proxmox-vm"
}
