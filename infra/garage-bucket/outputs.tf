output "access_key_id" {
  value = garage_key.this.access_key_id
}

output "secret_access_key" {
  value     = garage_key.this.secret_access_key
  sensitive = true
}
