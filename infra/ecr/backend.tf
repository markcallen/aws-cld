terraform {
  backend "s3" {
    bucket = "mca-terraform"
    key    = "infra/ecr.tfstate"
    region = "us-east-1"
  }
}
