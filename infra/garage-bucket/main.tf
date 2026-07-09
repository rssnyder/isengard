terraform {
  required_providers {
    garage = {
      source = "registry.terraform.io/arsolitt/garagehq"
    }
  }
}

# Garage has no JSON IAM policies; access is granted per-bucket to a key as
# read/write/owner. This module mirrors ./simple-bucket: one bucket + one key
# with full access, matching the MinIO simple-bucket pattern.

resource "garage_bucket" "this" {
  global_alias = var.name
}

resource "garage_key" "this" {
  name = var.user != null ? var.user : var.name
}

resource "garage_bucket_key" "this" {
  bucket_id     = garage_bucket.this.id
  access_key_id = garage_key.this.access_key_id
  read          = true
  write         = true
  owner         = true
}
