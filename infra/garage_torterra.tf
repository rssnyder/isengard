# Garage S3 on torterra.
#
# Cluster layout IS managed here. Two gotchas with arsolitt/garagehq v1.1.0 +
# Garage v2.3 (both verified against POST /v2/UpdateClusterLayout):
#   1. `id` must be the FULL 64-hex node id (from `garage node id -q` or the
#      admin GetClusterStatus), NOT the short 16-hex id that `garage status`
#      prints — the short form is rejected with "Invalid node identifier".
#   2. `tags` MUST be non-empty. Garage's NodeAssignedRole requires the `tags`
#      field, but the provider marshals Tags with `omitempty`, so an empty list
#      is dropped and the request fails the untagged-enum match (400 at the
#      role object's closing brace). A non-empty tag keeps the field present.
resource "garage_cluster_layout" "torterra" {
  roles {
    id       = "dd3a4eb3e653344dd93f2ab9e0324301159e91c733b17f763d4ce297177764b9"
    zone     = "torterra"
    capacity = "20G"
    tags     = ["torterra"]
  }
}

# Example bucket + key, mirroring the simple-bucket usage in s3_dsm.tf.
# Buckets can't be created until the layout above is applied.
module "garage_example" {
  source     = "./garage-bucket"
  name       = "example"
  depends_on = [garage_cluster_layout.torterra]
}
