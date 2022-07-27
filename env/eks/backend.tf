terraform {
  backend "s3" {
    bucket = "nval-terraform"
    key    = "eks.tfstate"
    region = "us-east-1"
  }
}
