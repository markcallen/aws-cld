module "local" {
  source = "../local"

  json_file = var.local_json_file
}

provider "aws" {
  region = module.local.bucket_region
}

resource "aws_s3_bucket" "terraform" {
  bucket = module.local.backend_bucket_name
}

resource "aws_s3_bucket_acl" "terraform_private" {
  bucket = aws_s3_bucket.terraform.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "terraform_versioning" {
  bucket = aws_s3_bucket.terraform.id
  versioning_configuration {
    status = "Enabled"
  }
}
