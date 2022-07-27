terraform {
  backend "s3" {
    bucket = "nval-terraform"
    key    = "ec2.tfstate"
    region = "us-east-1"
  }
}
