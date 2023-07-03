locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = var.project
  }
}

module "vpc_us_west" {
  source = "../modules/vpc"

  providers = {
    aws = aws.us_west
  }

  create_database_subnet_group = true
  name                         = "${var.project}-us-west-${var.environment}"
  cidr                         = var.cidr.us_west
  subnet_count                 = var.subnet_count

  tags = local.common_tags
}

module "vpc_us_east" {
  source = "../modules/vpc"

  providers = {
    aws = aws.us_east
  }

  create_database_subnet_group = true
  name                         = "${var.project}-us-east-${var.environment}"
  cidr                         = var.cidr.us_east
  subnet_count                 = var.subnet_count

  tags = local.common_tags
}
