variable "cluster_name" {
    type = string
    default = null
}

variable "talos_version" {
  type = string
  default = "1.13.4"
}

variable "kubernetes_version" {
  type = string
  default = "1.35.2"
}

variable "talos_image_factory_id" {
  type = string
  default = "dc7b152cb3ea99b821fcb7340ce7168313ce393d663740b791c36f6e95fc8586"
}

variable "proxmox_iso_datastore" {
  type = string
  default = "baelor"
}

variable "proxmox_nodes" {
  type = list(string)
}

variable "root_datastore" {
  type = string
  default = "data"
}

variable "gateway_ip" {
  type = string
  default = "192.168.2.1"
}

# if we pass in static ips we can one-shot the setup
variable "control_plane_nodes" {
  type = list(string)
}

variable "control_plane_disk" {
  type = number
  default = 20
}

variable "control_plane_cpu" {
  type = number
  default = 3
}

variable "control_plane_memory" {
  type = number
  default = 3
}

# if we pass in static ips we can one-shot the setup
variable "worker_nodes" {
  type = list(string)
}

variable "worker_disk" {
  type = number
  default = 20
}

variable "worker_cpu" {
  type = number
  default = 2
}

variable "worker_memory" {
  type = number
  default = 2
}

variable "schedule_on_control_plane" {
  type = bool
  default = true
}

variable "tags" {
  type = list(string)
  default = []
}

variable "cluster_vip" {
  type = string
  default = null
}

variable "enable_flux" {
  type = bool
  default = true
}
