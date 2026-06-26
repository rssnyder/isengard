proxmox_nodes       = ["pve0", "pve1"]
control_plane_nodes = ["192.168.2.110"]

worker_nodes  = ["192.168.2.109"]
worker_cpu    = 3
worker_memory = 6

metallb_cidr = "192.168.251.0/24"
