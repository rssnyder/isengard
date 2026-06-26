data "unifi_network" "default" {
  name = "Default"
}

resource "unifi_static_route" "metallb" {
  count     = var.metallb_cidr != null ? 1 : 0
  type      = "interface-route"
  name      = "metallb-${local.cluster_name}"
  network   = var.metallb_cidr
  interface = data.unifi_network.default.id
  distance  = 1
}
