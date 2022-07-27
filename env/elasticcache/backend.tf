terraform {
  backend "s3" {
    bucket = "nval-terraform"
    key    = "elasticcache.tfstate"
    region = "us-east-1"
  }
}
