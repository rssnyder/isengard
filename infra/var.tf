variable "instances" {
  description = "Map of instances"
  type        = map(any)
  default = {
    hurley = {
      ip = "173.22.88.59"
    }
    oca0 = {
      ip = "129.146.241.139"
    }
  }
}
