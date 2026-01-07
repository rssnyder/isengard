resource "minio_s3_bucket" "this" {
  bucket = var.name
  acl    = var.public ? "public" : "private"
}

resource "minio_iam_user" "this" {
  name          = var.user != null ? var.user : var.name
  force_destroy = false
}

resource "minio_iam_policy" "this" {
  name   = var.name
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
                "arn:aws:s3:::${var.name}*"
            ]
        }
    ]
}
EOF
}

resource "minio_iam_user_policy_attachment" "this" {
  user_name   = minio_iam_user.this.id
  policy_name = minio_iam_policy.this.id
}