terraform {
  backend "s3" {
    bucket = "mca-terraform"
    key    = "infra/acm.tfstate"
    region = "us-east-1"
  }
}

