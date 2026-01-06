locals {
  cluster_iteration  = "two"
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

module "k3s-server" {
  source = "./k3s-server"

  name = local.cluster_iteration
  tags = ["k3s", "master"]

  size_gb = 24
  cpu     = 2
  memory  = 4096

  iso_id     = proxmox_virtual_environment_download_file.debian_trixie.id
  public_key = data.local_file.ssh_public_key.content
  cluster    = local.proxmox_datacenter
  node_name  = data.proxmox_virtual_environment_nodes.this.names[0]
}

module "k3s-agents" {
  count = 2

  source = "./k3s-agent"

  iteration = local.cluster_iteration
  tags      = ["k3s"]

  size_gb = 24
  cpu     = 2
  memory  = 4096

  iso_id     = proxmox_virtual_environment_download_file.debian_trixie.id
  public_key = data.local_file.ssh_public_key.content
  cluster    = local.proxmox_datacenter
  node_name  = data.proxmox_virtual_environment_nodes.this.names[count.index % length(data.proxmox_virtual_environment_nodes.this.names)]

  server_ip = module.k3s-server.vm_ipv4_address

  depends_on = [module.k3s-server]
}

# access control

## ccm
resource "proxmox_virtual_environment_role" "ccm" {
  role_id = "CCM"

  privileges = [
    "Sys.Audit",
    "VM.Audit",
    "VM.GuestAgent.Audit",
  ]
}

resource "proxmox_virtual_environment_user" "kubernetes" {
  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.ccm.role_id
  }

  comment = "Kubernetes"
  user_id = "kubernetes@pve"
}

resource "proxmox_virtual_environment_user_token" "ccm" {
  comment    = "Kubernetes CCM"
  token_name = "ccm"
  user_id    = proxmox_virtual_environment_user.kubernetes.user_id
}

resource "proxmox_virtual_environment_acl" "ccm" {
  token_id = proxmox_virtual_environment_user_token.ccm.id
  role_id  = proxmox_virtual_environment_role.ccm.role_id

  path      = "/"
  propagate = true
}

## csi
resource "proxmox_virtual_environment_role" "csi" {
  role_id = "Kubernetes-CSI"

  privileges = [
    "VM.Audit",
    "VM.Config.Disk",
    "Datastore.Allocate",
    "Datastore.AllocateSpace",
    "Datastore.Audit",
  ]
}

resource "proxmox_virtual_environment_user" "kubernetes_csi" {
  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.csi.role_id
  }

  comment = "Kubernetes"
  user_id = "kubernetes-csi@pve"
}

resource "proxmox_virtual_environment_user_token" "csi" {
  comment    = "Kubernetes CSI"
  token_name = "csi"
  user_id    = proxmox_virtual_environment_user.kubernetes_csi.user_id
}

resource "proxmox_virtual_environment_acl" "csi" {
  token_id = proxmox_virtual_environment_user_token.csi.id
  role_id  = proxmox_virtual_environment_role.csi.role_id

  path      = "/"
  propagate = true
}