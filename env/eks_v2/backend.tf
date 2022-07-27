terraform {
  backend "s3" {
    bucket = "nval-terraform"
    key    = "eks_v2.tfstate"
    region = "us-east-1"
  }
}
