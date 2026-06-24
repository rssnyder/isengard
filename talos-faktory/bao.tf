resource "vault_auth_backend" "this" {
  type = "kubernetes"
  path = local.cluster_name

}

resource "vault_kubernetes_auth_backend_config" "this" {
  backend            = vault_auth_backend.this.path
  kubernetes_host    = "https://${local.control_plane_ip}:6443"
  kubernetes_ca_cert = base64decode(resource.talos_cluster_kubeconfig.kubeconfig.kubernetes_client_configuration.ca_certificate)
}

resource "vault_policy" "pve" {
  name = local.cluster_name

  policy = <<EOT
path "pvekv/*" {
  capabilities = ["read", "list"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "this" {
  backend                          = vault_auth_backend.this.path
  role_name                        = local.cluster_name
  bound_service_account_names      = ["external-secrets"]
  bound_service_account_namespaces = ["external-secrets"]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.pve.name]
}