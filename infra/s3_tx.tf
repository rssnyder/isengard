# resource "minio_s3_bucket" "tx_public" {
#   provider = minio.texas
#   bucket = "public"
#   acl    = "public"
# }