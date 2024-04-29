locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "aws-cld"
    Project     = var.project
  }
}

resource "aws_s3_bucket" "website" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = local.common_tags
}

resource "aws_s3_bucket_acl" "website_acl" {
  bucket     = aws_s3_bucket.website.id
  acl        = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.website]
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_versioning" "website_versioning" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = var.allowed_origins
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "website_public_read" {
  bucket     = aws_s3_bucket.website.id
  policy     = data.aws_iam_policy_document.website_public_read.json
  depends_on = [aws_s3_bucket_public_access_block.website]
}

data "aws_iam_policy_document" "website_public_read" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.website.bucket}/*",
    ]
    actions = ["S3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "404.jpeg"
  }
}

data "aws_iam_policy_document" "website_write" {
  statement {
    sid    = "AllowUserWrite"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.website.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.website.bucket}/*",
    ]
    actions = ["S3:*"]
  }
}

resource "aws_iam_policy" "website_write" {
  name        = "${var.bucket_name}_website_write"
  description = "${var.bucket_name} website write"
  policy      = data.aws_iam_policy_document.website_write.json
}
