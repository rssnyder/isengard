locals {
  proxmox_datacenter = "antoinette"
}

data "proxmox_virtual_environment_nodes" "this" {}

# vm setup
data "local_file" "ssh_public_key" {
  filename = "/home/riley/.ssh/id_rsa.pub"
}

resource "proxmox_virtual_environment_download_file" "debian_trixie" {
  content_type = "import"
  datastore_id = "zira-red"
  node_name    = data.proxmox_virtual_environment_nodes.this.names[0]
  url          = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
}
