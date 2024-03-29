terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.13"
}

module "bootstrap" {
  source = "../../../bootstrap/"

  project = "examples-ec2"
}

output "project" {
  value = module.bootstrap.project_name
}
