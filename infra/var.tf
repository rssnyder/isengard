variable "instances" {
  description = "Map of instances"
  type        = map(any)
  default = {
    kate {
      ip = "173.22.88.59"
    }
    oc0 = {
      ip = "129.146.252.4"
    }
    oca0 = {
      ip = "129.153.88.69"
    }
    oca1 = {
      ip = "129.146.17.125"
    }
    oca2 = {
      ip = "129.213.148.75"
    }
    oca3 = {
      ip = "129.158.60.88"
    }
    oca4 = {
      ip = "152.70.134.127"
    }
    oca5 = {
      ip = "129.146.80.191"
    }
    oca6 = {
      ip = "192.9.234.29"
    }
    oca7 = {
      ip = "150.230.38.249"
    }
    oca8 = {
      ip = "132.145.172.1"
    }
    oca9 = {
      ip = "132.145.220.39"
    }
  }
}
