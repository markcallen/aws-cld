locals {
  buckets = jsonencode(var.buckets)
}

resource "aws_iam_policy" "rekognition" {
  name        = "rekognition-policy-${var.project}-${var.environment}"
  description = format("Allow user to manage rekognition")
  path        = "/"
  policy      = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "s3:ListBucket",
              "s3:ListAllMyBuckets"
          ],
          "Resource": "*"
      },
      {
          "Sid": "s3Policies",
          "Effect": "Allow",
          "Action": [
              "s3:ListBucket",
              "s3:CreateBucket",
              "s3:GetBucketAcl",
              "s3:GetBucketLocation",
              "s3:GetObject",
              "s3:GetObjectAcl",
              "s3:GetObjectVersion",
              "s3:GetObjectTagging",
              "s3:GetBucketVersioning",
              "s3:GetObjectVersionTagging",
              "s3:PutBucketCORS",
              "s3:PutLifecycleConfiguration",
              "s3:PutBucketPolicy",
              "s3:PutObject",
              "s3:PutObjectTagging",
              "s3:PutBucketVersioning",
              "s3:PutObjectVersionTagging"
          ],
          "Resource": ${local.buckets}
      },
      {
          "Sid": "rekognitionPolicies",
          "Effect": "Allow",
          "Action": [
              "rekognition:*"
          ],
          "Resource": "*"
      },
      {
          "Sid": "groundTruthPolicies",
          "Effect": "Allow",
          "Action": [
              "groundtruthlabeling:*"
          ],
          "Resource": "*"
      }
  ]
}
EOT
  tags        = local.common_tags
}
