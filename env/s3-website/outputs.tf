output "bucket_name" {
  value = aws_s3_bucket.website.bucket
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "website_write_policy" {
  value = aws_iam_policy.website_write.arn
}
