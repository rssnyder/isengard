locals {
  cluster_iteration = "eight"
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
  node_name  = "pve0"
}

module "agent-deamons" {
  for_each = toset(data.proxmox_virtual_environment_nodes.this.names)

  source = "./k3s-agent"

  iteration = local.cluster_iteration
  tags      = ["k3s"]

  size_gb = 32
  cpu     = 2
  memory  = 6114

  iso_id     = proxmox_virtual_environment_download_file.debian_trixie.id
  public_key = data.local_file.ssh_public_key.content
  cluster    = local.proxmox_datacenter
  node_name  = each.key

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

resource "vault_kv_secret" "pve_ccm" {
  path = "${vault_mount.pve.path}/proxmox-cloud-controller-manager"
  data_json = jsonencode({
    "config.yaml" = <<EOF
clusters:
- url: https://${var.instances["pve0"].ip}:8006/api2/json
  insecure: true
  token_id: "${proxmox_virtual_environment_user_token.ccm.id}"
  token_secret: "${split("=", proxmox_virtual_environment_user_token.ccm.value)[1]}"
  region: ${local.proxmox_datacenter}
EOF
  })
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

resource "vault_kv_secret" "pve_csi" {
  path = "${vault_mount.pve.path}/proxmox-csi"
  data_json = jsonencode({
    "config.yaml" = <<EOF
clusters:
- url: https://${var.instances["pve0"].ip}:8006/api2/json
  insecure: true
  token_id: "${proxmox_virtual_environment_user_token.csi.id}"
  token_secret: "${split("=", proxmox_virtual_environment_user_token.csi.value)[1]}"
  region: ${local.proxmox_datacenter}
EOF
  })
}