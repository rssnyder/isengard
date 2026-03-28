variable "instances" {
  description = "Map of instances"
  type        = map(any)
  default = {
    hurley = {
      ip  = "192.168.2.2"
      mac = "E4:5F:01:C2:43:C7"
    }
    desktop = {
      ip  = "192.168.2.3"
      mac = "a8:a1:59:e0:48:9b"
    }
    home = {
      ip  = "192.168.2.239"
      mac = "F4:4D:30:65:A4:66"
    }
    # 5 claimed by cornelius
    zira = {
      ip  = "192.168.2.6"
      mac = "B8:CA:3A:B6:07:BD"
    }
    kate = {
      ip  = "192.168.2.7"
      mac = "8C:16:45:47:59:46"
    }
    ben = {
      ip = "192.168.2.8"
      mac = "00:e0:4c:36:c9:ae"
    }
    baelor = {
      ip = "192.168.2.9"
      mac = "b8:ae:ed:7f:3c:62"
    }
    # cluster
    pve0 = {
      ip  = "192.168.2.69"
      mac = "E8:6A:64:32:F3:9D"
    }
    pve1 = {
      ip  = "192.168.2.11"
      mac = "8C:16:45:9B:CA:24"
    }
    poweredge0 = {
      ip  = "192.168.2.12"
      mac = "E0:DB:55:0D:8F:8A"
    }
    poweredge1 = {
      ip  = "192.168.2.13"
      mac = "E0:DB:55:0D:8F:8C"
    }
    idrac = {
      ip  = "192.168.2.14"
      mac = "E0:DB:55:0D:8F:8E"
    }
    # smart home
    zigbee = {
      ip  = "192.168.2.20"
      mac = "E4:65:B8:CA:67:43"
    }
    # 5 claimed by frigate
    garagedoor = {
      ip  = "192.168.2.29"
      mac = "CC:7B:5C:4A:CC:6E"
    }
    # cameras
    front = {
      ip  = "192.168.2.30"
      mac = "9C:8E:CD:2D:80:9D"
    }
    back = {
      ip  = "192.168.2.31"
      mac = "E8:CA:C8:DA:11:D8"
    }
    garage = {
      ip  = "192.168.2.32"
      mac = "E8:CA:C8:7A:70:B3"
    }
    louie = {
      ip  = "192.168.2.33"
      mac = "E8:CA:C8:F8:37:B4"
    }
    lab = {
      ip  = "192.168.2.34"
      mac = "9C:8E:CD:2D:80:C1"
    }
    # external
    oca0 = {
      ip = "129.146.149.166"
    }
    oca1 = {
      ip = "129.153.217.210"
    }
    oca2 = {
      ip = "158.101.27.222"
    }
    oca3 = {
      ip = "144.24.58.138"
    }
    oca8 = {
      ip = "132.145.200.228"
    }
    tx = {
      ip = "99.145.203.56"
    }
    oci23 = {
      ip = "141.148.165.174"
    }
  }
}

variable "local_domain" {
  type    = string
  default = "r.ss"
}

variable "github_pages" {
  type    = list(any)
  default = ["185.199.108.153", "185.199.109.153", "185.199.110.153", "185.199.111.153"]
}
