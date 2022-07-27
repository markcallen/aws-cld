provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "repository" {
  count                = length(var.ecr_repositories)
  name                 = element(var.ecr_repositories, count.index)
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
