module "bao" {
  source = "github.com/rssnyder/terraform-proxmox-vm"

  vm_name = "bao"
  tags = ["vault","services"]

  node_name = "poweredge"
  iso_id = proxmox_virtual_environment_download_file.debian_trixie.id

  size_gb = 64

  pet = true
}

resource "vault_namespace" "pve" {
  path = "pve"
}

resource "vault_auth_backend" "pve" {
    # namespace = vault_namespace.pve.namespace
  type = "kubernetes"
}

data "kubernetes_config_map_v1" "pve" {
  metadata {
    name = "kube-root-ca.crt"
    namespace = "kube-system"
  }
}

resource "vault_kubernetes_auth_backend_config" "pve" {
  backend                = vault_auth_backend.pve.path
  kubernetes_host        = "https://eight:6443"
  kubernetes_ca_cert = data.kubernetes_config_map_v1.pve.data["ca.crt"]
#   disable_iss_validation = true
}

resource "vault_mount" "pve" {
    # namespace = vault_namespace.pve.namespace
  path        = "pvekv"
  type        = "kv"
  options     = { version = "1" }
  
  description = "KV Version 1 secret engine mount"
}


resource "vault_policy" "pve" {
  name = "pve"

  policy = <<EOT
path "pvekv/*" {
  capabilities = ["read", "list"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "pve" {
  backend                          = vault_auth_backend.pve.path
  role_name                        = "pve"
  bound_service_account_names      = ["external-secrets"]
  bound_service_account_namespaces = ["external-secrets"]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.pve.name]
  # audience                         = "vault"
}

# resource "vault_kv_secret_backend_v2" "pve" {
#     namespace = vault_namespace.pve.namespace
#   mount                = vault_mount.pve.path
#   max_versions         = 5
#   delete_version_after = 12600
#   cas_required         = true
# }

resource "vault_kv_secret" "example" {
    # namespace = vault_namespace.pve.namespace
path = "${vault_mount.pve.path}/test"
  # cas                 = 1
#   delete_all_versions = true
  data_json = jsonencode(
    {
      zip = "zap",
      foo = "bar"
    }
  )
#   data_json_wo_version = 1
}

# resource "vault_kubernetes_auth_backend_role" "pve" {
#   backend                          = vault_auth_backend.pve.path
#   role_name                        = "pve"
#   bound_service_account_names      = ["external-secrets"]
#   bound_service_account_namespaces = ["external-secrets"]
#   token_ttl                        = 3600
#   token_policies                   = ["default"]
#   audience                         = "vault"
# }