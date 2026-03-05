data "http" "home" {
  url = "https://ifconfig.me/ip"
}

resource "unifi_network" "default" {
  name    = "Default"
  purpose = "corporate"

  subnet       = "192.168.2.1/24"
  vlan_id      = 0
  dhcp_start   = "192.168.2.128"
  dhcp_stop    = "192.168.2.254"

  ipv6_pd_start = "::2"
  ipv6_pd_stop = "::7d1"
  ipv6_ra_priority = "high"
  dhcp_v6_start = "::2"
  dhcp_v6_stop = "::7d1"
  dhcp_enabled = true
}

resource "unifi_user" "test" {
  for_each = {for item, x in var.instances: item => {ip = x.ip, mac = x.mac} if contains(keys(x), "mac")}
  mac  = each.value.mac
  name = each.key
  note = "by isengard"

  fixed_ip   = each.value.ip 
  local_dns_record = "${each.key}.lab"
  network_id = unifi_network.default.id
}

resource "unifi_port_forward" "web" {
  for_each = toset(["80", "443"])

  name = "http(s)"
  
  port_forward_interface = "both"
  protocol = "tcp_udp"
  dst_port = each.key

  fwd_ip = var.instances["hurley"].ip
  fwd_port = each.key
}

resource "unifi_port_forward" "plex" {
  name = "plex"
  
  port_forward_interface = "both"
  protocol = "tcp_udp"
  dst_port = "32400"

  fwd_ip = var.instances["kate"].ip
  fwd_port = "32400"
}

resource "pihole_dns_record" "files" {
  domain = "files.${var.local_domain}"
  ip     = var.instances["kate"].ip
}

resource "pihole_dns_record" "whoami" {
  domain = "whoami.${var.local_domain}"
  ip     = "192.168.253.254"
}

resource "pihole_dns_record" "desktop" {
  domain = "desktop.${var.local_domain}"
  ip     = var.instances["desktop"].ip
}

resource "pihole_dns_record" "pve0" {
  domain = "pve0.${var.local_domain}"
  ip     = var.instances["pve0"].ip
}

# Static route for MetalLB LoadBalancer IPs to k8s control plane
resource "unifi_static_route" "metallb" {
  type     = "nexthop-route"
  name     = "metallb-k8s"
  network  = "192.168.252.0/24"
  next_hop = "192.168.2.140" # eight (k8s control plane)
  distance = 1
}
