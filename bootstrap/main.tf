locals {
  common_tags = {
    Environment = "bootstrap"
    ManagedBy   = "aws-cld"
    Project     = var.project == "" ? random_pet.bucket_name.id : var.project
  }

  project_name = var.project == "" ? random_pet.bucket_name.id : var.project
}

provider "aws" {
  region = var.region
}

resource "random_pet" "bucket_name" {
}
