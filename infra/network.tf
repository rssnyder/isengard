# clients: default landing network for anything joining without an explicit
# unifi_user network_id override (wifi or wired).
#
# can't become the untagged/native network -- unifi's built-in "Default"
# network (infra/local.tf's unifi_network.default, aka Services) is
# permanently pinned to vlan 1/native and can't be retagged or demoted.
# confirmed live 2026-08-28 (both apply orderings of the vlan swap failed).
# the "flip" needs a different approach -- see chat, not yet decided.
resource "unifi_network" "clients" {
  name    = "Clients"
  purpose = "corporate"

  subnet  = "192.168.3.0/24"
  vlan_id = 3

  dhcp_enabled = true
  dhcp_start   = "192.168.3.10"
  dhcp_stop    = "192.168.3.254"

  igmp_snooping = true
}

# iot: isolated, outbound-internet-only. its own resolver (cloudflare, not
# the services-vlan pihole) so it never needs a cross-zone allow just to do
# dns.
resource "unifi_network" "iot" {
  name    = "IoT"
  purpose = "corporate"

  subnet  = "192.168.4.0/24"
  vlan_id = 4

  dhcp_enabled = true
  dhcp_start   = "192.168.4.10"
  dhcp_stop    = "192.168.4.254"

  dhcp_dns = ["1.1.1.1", "1.0.0.1"]

  igmp_snooping = true
}

# Avoid WAN hairpinning for internal clients while preserving the public
# hostname and HTTPS certificate.
resource "unifi_dns_record" "git" {
  name   = "git.ttdsm.org"
  type   = "A"
  record = "192.168.2.10"
}

# built-in zones created by the site's zone-based-firewall migration
# (2026-08-22) -- not managed here, just referenced.
data "unifi_firewall_zone" "internal" {
  name = "Internal"
}

data "unifi_firewall_zone" "external" {
  name = "External"
}

# A network belongs to exactly one zone. Put Services in its own zone so it
# can initiate connections to IoT without granting the Clients network the
# same access. The IoT zone is kept separate below.
resource "unifi_firewall_zone" "services" {
  name     = "Services"
  networks = [unifi_network.default.id]
}

resource "unifi_firewall_zone" "iot" {
  name     = "IoT"
  networks = [unifi_network.iot.id]
}

resource "unifi_firewall_zone_policy" "iot_to_internet" {
  name        = "iot-to-internet"
  description = "iot: outbound internet only"
  action      = "ALLOW"

  # no auto_allow_return_traffic here: that generates a paired policy for
  # the opposite zone pair, which the api rejects when the destination is
  # External -- return traffic for outbound connections is already handled
  # unconditionally by the gateway's own nat/conntrack, not the zone-policy
  # engine, so there's nothing for it to do here anyway.

  source = {
    zone_id = unifi_firewall_zone.iot.id
  }
  destination = {
    zone_id = data.unifi_firewall_zone.external.id
  }
}

resource "unifi_firewall_zone_policy" "services_to_iot" {
  name        = "services-to-iot"
  description = "services: allow initiating connections to iot"
  action      = "ALLOW"

  source = {
    zone_id = unifi_firewall_zone.services.id
  }
  destination = {
    zone_id = unifi_firewall_zone.iot.id
  }
}

resource "unifi_firewall_zone_policy" "services_to_clients" {
  name        = "services-to-clients"
  description = "services: allow initiating connections to clients (e.g. frigate -> cameras)"
  action      = "ALLOW"

  # unlike the iot_to_internet policy above, this pair isn't NATed -- there's
  # no conntrack layer doing return-traffic bookkeeping for us, so without
  # this the camera's responses (e.g. RTSP replies) hit the base
  # internal-to-services block and the connection just times out. This
  # generates a paired internal->services policy scoped to established/
  # related traffic only -- it does not open services to connections
  # initiated from clients.
  auto_allow_return_traffic = true

  source = {
    zone_id = unifi_firewall_zone.services.id
  }
  destination = {
    zone_id = data.unifi_firewall_zone.internal.id
  }
}

resource "unifi_firewall_zone_policy" "iot_to_services_block" {
  name        = "iot-to-services-block"
  description = "iot: cannot initiate connections to services"
  action      = "BLOCK"

  source = {
    zone_id = unifi_firewall_zone.iot.id
  }
  destination = {
    zone_id = unifi_firewall_zone.services.id
  }
}

resource "unifi_firewall_zone_policy" "internal_to_iot_block" {
  name        = "internal-to-iot-block"
  description = "clients: no initiating connections to iot devices"
  action      = "BLOCK"

  source = {
    zone_id = data.unifi_firewall_zone.internal.id
  }
  destination = {
    zone_id = unifi_firewall_zone.iot.id
  }
}

# iot wifi: separate ssid mapped to the iot network/zone above. wpa2-psk
# (no wpa3) for broad iot device compatibility -- a lot of smart plugs/bulbs
# still don't support wpa3.
data "unifi_user_group" "default" {
  name = "Default"
}

resource "random_password" "iot_wifi" {
  length  = 20
  special = false
}

resource "vault_kv_secret" "iot_wifi" {
  path = "${vault_mount.pve.path}/iot-wifi"
  data_json = jsonencode({
    ssid       = "Bastille"
    passphrase = random_password.iot_wifi.result
  })
}

data "unifi_ap_group" "all" {
  name = "All APs"
}

resource "unifi_wlan" "bastille" {
  name = "Bastille"

  network_id    = unifi_network.iot.id
  user_group_id = data.unifi_user_group.default.id
  ap_group_ids  = [data.unifi_ap_group.all.id]

  security   = "wpapsk"
  passphrase = random_password.iot_wifi.result
}
