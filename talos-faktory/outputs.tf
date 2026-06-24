output "talosconfig" {
  value     = data.talos_client_configuration.client_config.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = resource.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive = true
}

resource "local_file" "talosconfig" {
  content  = data.talos_client_configuration.client_config.talos_config
  filename = "${path.module}/${local.cluster_name}.talosconfig"
}

resource "local_file" "kubeconfig" {
  content  = resource.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  filename = "${path.module}/${local.cluster_name}.kubeconfig"
}