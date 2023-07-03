terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.0"
      configuration_aliases = [aws.us_east, aws.us_west]
    }
  }

  required_version = ">= 0.13"
}
