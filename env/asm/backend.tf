terraform {
  backend "s3" {
    bucket = "nval-terraform"
    key    = "asm.tfstate"
    region = "us-east-1"
  }
}

