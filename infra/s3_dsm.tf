# public assets

resource "minio_s3_bucket" "public" {
  bucket = "public"
  acl    = "public"
}

module "g3_public" {
  source     = "./garage-bucket"
  name       = "public"
  depends_on = [garage_cluster_layout.torterra]
}

# storing dndgenerator images

resource "minio_s3_bucket" "dndgenerator" {
  bucket = "dndgenerator"
  acl    = "public"
}

resource "minio_iam_user" "dgapi" {
  name          = "dgapi"
  force_destroy = false
}

resource "minio_iam_policy" "dndgenerator_put" {
  name   = "dndgenerator_put"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:Put*"
            ],
            "Resource": [
                "arn:aws:s3:::dndgenerator*"
            ]
        }
    ]
}
EOF
}

resource "minio_iam_user_policy_attachment" "dgapi-dndgenerator_put" {
  user_name   = minio_iam_user.dgapi.id
  policy_name = minio_iam_policy.dndgenerator_put.id
}

module "g3_dndgenerator" {
  source     = "./garage-bucket"
  name       = "dndgenerator"
  depends_on = [garage_cluster_layout.torterra]
}

# dst backups

resource "minio_s3_bucket" "discord-stock-ticker" {
  bucket = "discord-stock-ticker"
  acl    = "private"
}

module "g3_discord-stock-ticker" {
  source     = "./garage-bucket"
  name       = "discord-stock-ticker"
  depends_on = [garage_cluster_layout.torterra]
}

resource "minio_s3_bucket" "isengard" {
  bucket = "isengard"
  acl    = "private"
}

resource "minio_iam_user" "isengard" {
  name          = "isengard"
  force_destroy = false
}

resource "minio_iam_policy" "dst_admin" {
  name   = "dst_admin"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::discord-stock-ticker*"
            ]
        }
    ]
}
EOF
}

resource "minio_iam_user_policy_attachment" "isengard-dst_admin" {
  user_name   = minio_iam_user.isengard.id
  policy_name = minio_iam_policy.dst_admin.id
}

module "g3_isengard" {
  source     = "./garage-bucket"
  name       = "isengard"
  depends_on = [garage_cluster_layout.torterra]
}

module "s3_longhorn" {
  source = "./simple-bucket"
  name   = "longhorn"
}

module "g3_longhorn" {
  source     = "./garage-bucket"
  name       = "longhorn"
  depends_on = [garage_cluster_layout.torterra]
}

module "s3_harness" {
  source = "./simple-bucket"
  name   = "harness"
}

module "g3_harness" {
  source     = "./garage-bucket"
  name       = "harness"
  depends_on = [garage_cluster_layout.torterra]
}

module "s3_pg2s3" {
  source = "./simple-bucket"
  name   = "pg2s3"
}

module "g3_pg2s3" {
  source     = "./garage-bucket"
  name       = "pg2s3"
  depends_on = [garage_cluster_layout.torterra]
}

module "s3_cnpg" {
  source = "./simple-bucket"
  name   = "cnpg"
}

module "g3_cnpg" {
  source     = "./garage-bucket"
  name       = "cnpg"
  depends_on = [garage_cluster_layout.torterra]
}

module "s3_burrito" {
  source = "./simple-bucket"
  name   = "burrito"
}

module "g3_burrito" {
  source     = "./garage-bucket"
  name       = "burrito"
  depends_on = [garage_cluster_layout.torterra]
}

module "s3_b4w" {
  source = "./simple-bucket"
  name   = "b4w"
}

module "g3_b4w" {
  source     = "./garage-bucket"
  name       = "b4w"
  depends_on = [garage_cluster_layout.torterra]
}
