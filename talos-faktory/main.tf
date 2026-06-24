locals {
  cluster_name = var.cluster_name != null ? var.cluster_name : terraform.workspace
  tags = concat(var.tags, [
    "talos", "terraform"
  ])
}

resource "proxmox_download_file" "talos_x86" {
  content_type            = "iso"
  datastore_id            = var.proxmox_iso_datastore
  node_name                 = var.proxmox_nodes[0]
  url                     = "https://factory.talos.dev/image/${var.talos_image_factory_id}/v${var.talos_version}/nocloud-amd64.raw.xz"
  decompression_algorithm = "zst"
  file_name               = "talos-${local.cluster_name}-v${var.talos_version}-nocloud-amd64.img"
  overwrite               = false
}

resource "talos_machine_secrets" "machine_secrets" {
  talos_version = "v${var.talos_version}"
}

data "talos_client_configuration" "client_config" {
  cluster_name         = local.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = var.control_plane_nodes
  nodes                = var.worker_nodes
}

data "talos_machine_configuration" "control_plane" {
  cluster_name       = local.cluster_name
  cluster_endpoint   = "https://${local.control_plane_ip}:6443"
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.machine_secrets.machine_secrets
  kubernetes_version = "v${var.kubernetes_version}"
  talos_version      = "v${var.talos_version}"

  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk  = "/dev/vda" # virtio0 disk
          image = "factory.talos.dev/installer/${var.talos_image_factory_id}:v${var.talos_version}"
        }
        # network = merge(
        #   {
        #     # nameservers = ["192.168.2.1", "1.1.1.1"]
        #   },
        #   var.cluster_vip != null ? {
        #     interfaces = [{
        #       interface = "eth0"
        #       vip = {
        #         ip = var.cluster_vip
        #       }
        #     }]
        #   }: {}
        # )
      }
      cluster = {
        allowSchedulingOnControlPlanes = true
        extraManifests = concat(
          [],
          var.enable_flux ? [
            "https://github.com/controlplaneio-fluxcd/flux-operator/releases/latest/download/install.yaml",
            "https://raw.githubusercontent.com/rssnyder/isengard/refs/heads/master/k8s/clusters/${local.cluster_name}/flux.yaml"
          ] : []
        )
      }
    })
  ]
}

data "talos_machine_configuration" "worker" {
  cluster_name       = local.cluster_name
  cluster_endpoint   = "https://${local.control_plane_ip}:6443"
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.machine_secrets.machine_secrets
  kubernetes_version = "v${var.kubernetes_version}"
  talos_version      = "v${var.talos_version}"

  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk  = "/dev/vda" # virtio0 disk
          image = "factory.talos.dev/installer/${var.talos_image_factory_id}:v${var.talos_version}"
        }
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "control_plane" {
  depends_on                  = [proxmox_virtual_environment_vm.control_plane]

  for_each = toset(var.control_plane_nodes)

  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane.machine_configuration
  node                        = each.key
}

resource "talos_machine_configuration_apply" "worker" {
  depends_on                  = [proxmox_virtual_environment_vm.worker]

  for_each = toset(var.worker_nodes)

  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = each.key
}

resource "talos_machine_bootstrap" "control_plane" {
  depends_on           = [talos_machine_configuration_apply.control_plane]

  for_each = toset(var.control_plane_nodes)

  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = each.key
  # endpoint             = each.key
}

resource "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on           = [talos_machine_bootstrap.control_plane]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = local.control_plane_ip

  lifecycle {
    replace_triggered_by = [terraform_data.cluster_endpoint]
  }
}

locals {
  control_plane_ip = var.control_plane_nodes[0]
}

resource "terraform_data" "cluster_endpoint" {
  input = local.control_plane_ip
}
