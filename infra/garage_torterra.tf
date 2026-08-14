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
# module "garage_example" {
#   source     = "./garage-bucket"
#   name       = "example"
#   depends_on = [garage_cluster_layout.torterra]
# }

# # terraform/opentofu network mirror for the localdhcp provider: static JSON
# # + release zips, uploaded by the provider repo's release action and served
# # publicly through caddy -> garage s3_web (see mirror/ in
# # git.ttdsm.org/rssnyder/terraform-provider-localdhcp). The key is the
# # MIRROR_S3_* secret pair in that repo's actions settings.
# module "garage_tf_mirror" {
#   source     = "./garage-bucket"
#   name       = "tf.ttdsm.org"
#   depends_on = [garage_cluster_layout.torterra]
# }

# # hand the bucket key to the provider repo's release action, which uploads
# # the mirror tree with it
# data "forgejo_repository" "localdhcp" {
#   owner = "rssnyder"
#   name  = "terraform-provider-localdhcp"
# }

# resource "forgejo_repository_action_secret" "mirror_s3_access_key" {
#   repository_id = data.forgejo_repository.localdhcp.id
#   name          = "MIRROR_S3_ACCESS_KEY"
#   data          = module.garage_tf_mirror.access_key_id
# }

# resource "forgejo_repository_action_secret" "mirror_s3_secret_key" {
#   repository_id = data.forgejo_repository.localdhcp.id
#   name          = "MIRROR_S3_SECRET_KEY"
#   data          = module.garage_tf_mirror.secret_access_key
# }

# # arsolitt/garagehq v1.1.0 has no website-access attribute on garage_bucket,
# # so flip it through the admin API instead. Re-runs on bucket replacement.
# resource "terraform_data" "garage_tf_mirror_website" {
#   triggers_replace = module.garage_tf_mirror.bucket_id

#   provisioner "local-exec" {
#     command = <<-EOT
#       curl -fsS -X POST \
#         -H "Authorization: Bearer $GARAGE_ADMIN_TOKEN" \
#         -H "Content-Type: application/json" \
#         -d '{"websiteAccess":{"enabled":true,"indexDocument":"index.html"}}' \
#         "http://torterra.r.ss:3903/v2/UpdateBucket?id=${module.garage_tf_mirror.bucket_id}"
#     EOT
#     environment = {
#       GARAGE_ADMIN_TOKEN = var.garage_torterra_admin_token
#     }
#   }
# }
