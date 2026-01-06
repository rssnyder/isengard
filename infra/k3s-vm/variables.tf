variable "node_name" {
  type = string
  description = "proxmox node name"
}

variable "name" {
  type = string
  description = "vm name"
}

variable "public_key" {
  type = string
  description = "public key for ssh access"
}

variable "size_gb" {
  type = number
  description = "disk size in gb"
  default = 8
}

# variable "additional_disks" {
#   type = list(number)
#   description = "additional disks to add, in gb"
#   default = []
# }

variable "cpu" {
  type = number
  description = "cores"
  default = 2
}

variable "memory" {
  type = number
  description = "mb"
  default = 2048
}

variable "iso_id" {
  type = string
  description = "source iso to use for vm"
}

variable "dns_name" {
  type = string
  description = "custom dns name"
  default = null
}

variable "tags" {
  type = list(string)
  description = "tags"
  default = []
}

variable "cluster" {
  type = string
  description = "name of the pve cluster"
}

variable "server_ip" {
  type = string
  description = "k3s server ip"
}