variable "node_name" {
  type        = string
  description = "proxmox node to place the container on"
}

variable "hostname" {
  type        = string
  description = "container hostname"
}

variable "vm_id" {
  type        = number
  description = "container id, auto-assigned by proxmox when null"
  default     = null
}

variable "template_file_id" {
  type        = string
  description = "id of the downloaded lxc template (proxmox_virtual_environment_download_file)"
}

variable "datastore_id" {
  type        = string
  description = "storage for the container rootfs"
  default     = "baelor"
}

variable "size_gb" {
  type        = number
  description = "rootfs size in gb"
  default     = 4
}

variable "cpu" {
  type        = number
  description = "cores"
  default     = 1
}

variable "memory" {
  type        = number
  description = "mb"
  default     = 512
}

variable "bridge" {
  type        = string
  description = "network bridge"
  default     = "vmbr0"
}

variable "ip_address" {
  type        = string
  description = "ipv4 to reserve via unifi dhcp fixed-ip, e.g. 192.168.2.140 (not cidr — the container itself stays on dhcp)"
}

variable "network_id" {
  type        = string
  description = "unifi network id the fixed-ip reservation belongs to"
}

variable "public_key" {
  type        = string
  description = "ssh public key installed for the default user"
}

variable "username" {
  type        = string
  description = "account the ssh key/password apply to (lxc user_account only configures root)"
  default     = "root"
}

variable "tags" {
  type        = list(string)
  description = "tags"
  default     = ["monitoring"]
}

variable "prometheus_port" {
  type        = number
  description = "prometheus-pve-exporter listen port, registered in the _prometheus._tcp SRV record"
  default     = 9221
}
