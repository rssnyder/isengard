module "prometheus" {
  source = "git::ssh://git@git.ttdsm.org/rssnyder/terraform-proxmox-vm.git"

  vm_name = "prometheus"
  tags    = ["monitoring", "services"]
  cpu     = 2
  memory  = 2048

  node_name = "pve1"
  iso_id    = proxmox_download_file.debian_trixie.id

  size_gb = 32
}

module "plex" {
  source = "git::ssh://git@git.ttdsm.org/rssnyder/terraform-proxmox-vm.git"

  vm_name = "plex"
  tags    = ["plex"]

  node_name = "pve2"
  iso_id    = proxmox_download_file.debian_trixie.id

  cpu     = 4
  memory  = 1024 * 16
  size_gb = 64

  ip_address = "192.168.2.100/24"
}

module "torterra" {
  source = "git::ssh://git@git.ttdsm.org/rssnyder/terraform-proxmox-vm.git"

  vm_name = "torterra"
  tags    = ["docker"]

  node_name = "poweredge"
  iso_id    = proxmox_download_file.debian_trixie.id

  cpu     = 2
  memory  = 1024 * 2
  size_gb = 32

  pet = true
}

module "cornelius" {
  source = "git::ssh://git@git.ttdsm.org/rssnyder/terraform-proxmox-vm.git?ref=cornelius"

  vm_name = "cornelius"
  tags    = ["nas", "core"]

  node_name = "poweredge"
  iso_id    = proxmox_download_file.debian_trixie.id

  cpu    = 6
  memory = 1024 * 24

  ip_address = "192.168.2.5/24"

  size_gb      = 64
  scsi_hardware = "virtio-scsi-single"

  # mass
  #  ata-ST26000NM000C-3WE103_ZXA0D5PN
  #  ata-ST26000NM000C-3WE103_ZXA0A40J

  # red
  #  ata-WDC_WD181KFGX-68AFPN0_4BHE2GWH
  #  ata-WDC_WD181KFGX-68AFPN0_4BHDSZRH

  pet = true
}

module "git" {
  source = "git::ssh://git@git.ttdsm.org/rssnyder/terraform-proxmox-vm.git"

  vm_name = "git"

  node_name = "pve0"

  size_gb = 32

  cpu    = 2
  memory = 1024 * 4
}

module "actions" {
  source = "git::ssh://git@git.ttdsm.org/rssnyder/terraform-proxmox-vm.git"

  vm_name = "actions"

  node_name = "pve1"

  size_gb = 32

  cpu    = 3
  memory = 1024 * 4
}

module "edge" {
  source = "git::ssh://git@git.ttdsm.org/rssnyder/terraform-proxmox-vm.git?ref=feat/nic-queues-and-dns"

  vm_name = "edge"
  tags    = ["network", "caddy"]

  node_name = "poweredge"
  iso_id    = proxmox_download_file.debian_trixie.id

  # caddy saturated all 4 vcpus (335-389% of 400%) at ~1 Gbps of tls proxying,
  # while the host still had idle. 6 puts allocation at 14 vcpu on 12 threads —
  # mild oversubscription, and the e5-2430 is 6c/12t so this is ~3 physical cores.
  cpu     = 6
  memory  = 1024 * 2
  size_gb = 16

  ip_address = "192.168.2.10/24"

  # measured, do not "fix" this to match vcpus: multiqueue is a regression on
  # this host at every concurrency level. single stream 1q~470 / 6q~295 Mbps,
  # 8 streams 1q~3100 / 6q~2300, confirmed in both ascending and descending
  # sweeps. spreading softirq across vcpus costs more in cross-cpu wakeups on an
  # oversubscribed 2012 xeon than it gains in parallelism.
  nic_queues = 1

  # the router is authoritative for .r.ss; a static ip_address carries no DNS,
  # and the DHCP-provided resolver (pihole on hurley) does not serve that zone.
  dns_servers = ["192.168.2.1"]
}
