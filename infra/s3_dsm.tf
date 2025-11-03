# public assets

resource "minio_s3_bucket" "public" {
  bucket = "public"
  acl    = "public"
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

# dst backups

resource "minio_s3_bucket" "discord-stock-ticker" {
  bucket = "discord-stock-ticker"
  acl    = "private"
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

# velero

resource "minio_s3_bucket" "velero" {
  bucket = "velero"
  acl    = "private"
}

resource "minio_iam_user" "lab_velero" {
  name          = "lab_velero"
  force_destroy = false
}

resource "minio_iam_user" "oc_velero" {
  name          = "oc_velero"
  force_destroy = false
}

resource "minio_iam_user" "ocdr_velero" {
  name          = "ocdr_velero"
  force_destroy = false
}

resource "minio_iam_user" "urban_velero" {
  name          = "urban_velero"
  force_destroy = false
}

resource "minio_iam_policy" "velero" {
  name   = "velero"
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
                "arn:aws:s3:::velero*"
            ]
        }
    ]
}
EOF
}

resource "minio_iam_user_policy_attachment" "lab_velero" {
  user_name   = minio_iam_user.lab_velero.id
  policy_name = minio_iam_policy.velero.id
}

resource "minio_iam_user_policy_attachment" "oc_velero" {
  user_name   = minio_iam_user.oc_velero.id
  policy_name = minio_iam_policy.velero.id
}

resource "minio_iam_user_policy_attachment" "ocdr_velero" {
  user_name   = minio_iam_user.ocdr_velero.id
  policy_name = minio_iam_policy.velero.id
}

resource "minio_iam_user_policy_attachment" "urban_velero" {
  user_name   = minio_iam_user.urban_velero.id
  policy_name = minio_iam_policy.velero.id
}

module "s3_longhorn" {
  source = "./simple-bucket"
  name   = "longhorn"
}

module "s3_harness" {
  source = "./simple-bucket"
  name   = "harness"
}

module "s3_pg2s3" {
  source = "./simple-bucket"
  name   = "pg2s3"
}

module "s3_cnpg" {
  source = "./simple-bucket"
  name   = "cnpg"
}

module "s3_burrito" {
  source = "./simple-bucket"
  name   = "burrito"
}

module "s3_b4w" {
  source = "./simple-bucket"
  name   = "b4w"
}
