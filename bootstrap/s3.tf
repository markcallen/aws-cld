resource "aws_s3_bucket" "terraform" {
  bucket        = "${local.project_name}-${var.s3_extension}"
  force_destroy = true

  tags = local.common_tags
}

resource "aws_s3_bucket_acl" "terraform_private" {
  bucket = aws_s3_bucket.terraform.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.terraform.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "terraform_versioning" {
  bucket = aws_s3_bucket.terraform.id
  versioning_configuration {
    status = "Enabled"
  }
}
