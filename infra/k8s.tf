data "digitalocean_kubernetes_versions" "latest" {
  version_prefix = "1.23."
}

resource "digitalocean_kubernetes_cluster" "ssenrah" {
  name   = "ssenrah"
  region = "nyc1"

  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.latest.latest_version

  maintenance_policy {
    start_time  = "04:00"
    day         = "sunday"
  }

  node_pool {
    name       = "core"
    size       = "s-1vcpu-1gb"
    node_count = 3
  }
}