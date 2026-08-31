output "ip_address" {
  value = var.ip_address
}

output "hostname" {
  value = "${var.hostname}.r.ss"
}

output "username" {
  value = var.username
}

output "vm_id" {
  value = proxmox_virtual_environment_container.this.vm_id
}
