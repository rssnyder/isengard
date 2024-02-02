resource "minio_s3_bucket" "public" {
  bucket = "public"
  acl    = "public"
}

# resource "minio_s3_bucket" "tx_public" {
#   provider = minio.texas
#   bucket = "public"
#   acl    = "public"
# }

resource "minio_s3_bucket" "discord-stock-ticker" {
  bucket = "discord-stock-ticker"
  acl    = "private"
}

resource "minio_s3_bucket" "isengard" {
  bucket = "isengard"
  acl    = "private"
}

resource "minio_iam_user" "isengard" {
   name = "isengard"
   force_destroy = false
}

resource "minio_iam_policy" "dst_admin" {
  name = "dst_admin"
  policy= <<EOF
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

resource "minio_s3_bucket" "harness" {
  bucket = "harness"
  acl    = "private"
}

resource "minio_iam_user" "harness_work" {
   name = "harness_work"
   force_destroy = false
}

resource "minio_iam_policy" "harness_admin" {
  name = "harness_admin"
  policy= <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::harness*"
            ]
        }
    ]
}
EOF
}

resource "minio_iam_user_policy_attachment" "harness_work-harness_admin" {
  user_name   = minio_iam_user.harness_work.id
  policy_name = minio_iam_policy.harness_admin.id
}

resource "minio_s3_bucket" "k8s" {
  bucket = "k8s"
  acl    = "private"
}

resource "minio_iam_user" "longhorn" {
   name = "longhorn"
   force_destroy = false
}

resource "minio_iam_policy" "longhorn" {
  name = "longhorn"
  policy= <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::k8s/longhorn/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::k8s"
            ]
        }
    ]
}
EOF
}

resource "minio_iam_user_policy_attachment" "longhorn" {
  user_name   = minio_iam_user.longhorn.id
  policy_name = minio_iam_policy.longhorn.id
}

resource "minio_iam_user" "pg2s3" {
   name = "pg2s3"
   force_destroy = false
}