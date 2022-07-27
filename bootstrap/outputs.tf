output "terraform_bucket_name" {
  value = aws_s3_bucket.terraform.bucket
}

output "project_name" {
  value = local.project_name
}

