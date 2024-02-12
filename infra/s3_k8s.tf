resource "minio_s3_bucket" "loki-chunks" {
  provider = minio.k8s
  bucket = "loki-chunks"
  acl    = "private"
}

resource "minio_s3_bucket" "loki-ruler" {
  provider = minio.k8s
  bucket = "loki-ruler"
  acl    = "private"
}

resource "minio_s3_bucket" "loki-admin" {
  provider = minio.k8s
  bucket = "loki-admin"
  acl    = "private"
}

resource "minio_iam_user" "loki" {
  provider = minio.k8s
   name = "loki"
   force_destroy = false
}

resource "minio_iam_policy" "loki" {
  provider = minio.k8s
  name = "loki"
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
                "arn:aws:s3:::loki*"
            ]
        }
    ]
}
EOF
}

resource "minio_iam_user_policy_attachment" "loki" {
  provider = minio.k8s
  user_name   = minio_iam_user.loki.id
  policy_name = minio_iam_policy.loki.id
}