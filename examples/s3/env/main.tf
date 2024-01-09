resource "random_pet" "bucket" {
}

module "s3" {
  source = "../../../env/s3"

  project     = var.project
  environment = var.environment

  bucket_name = "aws-cld-s3-example-${random_pet.bucket.id}"
}
