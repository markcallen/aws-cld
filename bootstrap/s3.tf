locals {
  project_name = var.project == "" ? random_pet.bucket_name.id : var.project
}

provider "aws" {
  region = var.region
}

resource "random_pet" "bucket_name" {
}

resource "aws_s3_bucket" "terraform" {
  bucket = "${local.project_name}-${var.s3_extension}"
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
