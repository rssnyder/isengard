variable "instances" {
  description = "Map of instances"
  type        = map(any)
  default = {
    hurley = {
      ip = "173.22.88.59"
    }
    hurley_local = {
      ip = "192.168.0.3"
    }
    oca0 = {
      ip = "129.146.241.139"
    }
    oca1 = {
      ip = "129.153.88.119"
    }
  }
}
