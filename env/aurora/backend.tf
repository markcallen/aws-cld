terraform {
  backend "s3" {
    bucket = "nval-terraform"
    key    = "aurora.tfstate"
    region = "us-east-1"
  }
}
