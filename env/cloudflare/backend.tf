terraform {
  backend "s3" {
    bucket = "nval-terraform"
    key    = "cloudflare.tfstate"
    region = "us-east-1"
  }
}
