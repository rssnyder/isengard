variable "instances" {
  description = "Map of instances"
  type        = map(any)
  default = {
    zira = {
      ip = "192.168.0.2"
    }
    cornelius = {
      ip = "192.168.0.6"
    }
    hurley = {
      ip = "173.22.88.59"
    }
    hurley-local = {
      ip = "192.168.0.3"
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
    oca4 = {
      ip = "129.153.95.143"
    }
    oca5 = {
      ip = "129.146.157.81"
    }
    oca6 = {
      ip = "144.24.63.75"
    }
    oca7 = {
      ip = "129.146.43.216"
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
  }
}
