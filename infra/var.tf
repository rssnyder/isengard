variable "instances" {
  description = "Map of instances"
  type        = map(any)
  default = {
    home = {
      ip = "216.82.42.181"
    }
    zira = {
      ip = "192.168.2.6"
    }
    t480-0 = {
      ip = "192.168.2.69"
    }
    hurley = {
      ip = "192.168.2.2"
    }
    charlie = {
      ip = "192.168.0.10"
    }
    desktop-5cdkr1f = {
      ip = "192.168.2.4"
    }
    ingress = {
      ip = "192.168.254.4"
    }
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
      ip = "129.153.144.225"
    }
    oca9 = {
      ip = "129.158.255.22"
    }
    oca10 = {
      ip = "129.158.237.210"
    }
    oca11 = {
      ip = "129.158.243.254"
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
