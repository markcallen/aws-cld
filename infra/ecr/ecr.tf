module "local" {
  source = "../../local"
}

provider "aws" {
  region = module.local.ecr_region
}

resource "aws_ecr_repository" "repository" {
  count                = length(module.local.ecr_repositories)
  name                 = element(module.local.ecr_repositories, count.index)
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
