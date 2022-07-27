terraform {
  backend "s3" {
    bucket = "nval-terraform"
    key    = "autoscaler.tfstate"
    region = "us-east-1"
  }
}

