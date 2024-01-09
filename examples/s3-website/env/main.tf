resource "random_pet" "bucket" {
}

module "website" {
  source = "../../../env/s3-website"

  project     = var.project
  environment = var.environment

  bucket_name = "aws-cld-website-example-${random_pet.bucket.id}"

  allowed_origins = ["https://www.markcallen.com", "https://markcallen.com"]
}

resource "aws_iam_group_policy_attachment" "website_write" {
  count      = 1
  group      = "engineering"
  policy_arn = module.website.website_write_policy
}
