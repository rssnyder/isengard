resource "vault_auth_backend" "sa-lab" {
  type = "kubernetes"
  path = "sa-lab"

}

resource "vault_kubernetes_auth_backend_config" "sa-lab" {
  backend                = vault_auth_backend.sa-lab.path
  kubernetes_host        = "https://eight:6443"
  kubernetes_ca_cert = data.kubernetes_config_map_v1.pve.data["ca.crt"]
}

resource "vault_mount" "sa-lab" {
  path        = "sa-lab"
  type        = "kv"
  options     = { version = "1" }
  
  description = "KV Version 1 secret engine mount"
}


resource "vault_policy" "sa-lab" {
  name = "sa-lab"

  policy = <<EOT
path "sa-lab/*" {
  capabilities = ["read", "list"]
}

path "sys/mounts" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "sa-lab" {
  backend                          = vault_auth_backend.sa-lab.path
  role_name                        = "sa-lab"
  bound_service_account_names      = ["work-shared-pve"]
  bound_service_account_namespaces = ["harness-delegate-ng"]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.sa-lab.name]
}

resource "vault_kv_secret" "sa-lab" {

  path      = "${vault_mount.sa-lab.path}/test"
  data_json = jsonencode({
    zip = "zap"
  })
}
