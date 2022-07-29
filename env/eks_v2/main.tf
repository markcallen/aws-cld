locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = var.project
  }
}

data "aws_vpc" "us_east" {
  provider = aws.us_east

  tags = {
    Name        = "${var.project}-us-east-${var.environment}"
    Project     = var.project
    Environment = var.environment
  }
}

data "aws_vpc" "us_west" {
  provider = aws.us_west

  tags = {
    Name        = "${var.project}-us-west-${var.environment}"
    Project     = var.project
    Environment = var.environment
  }
}

module "eks_us_east" {
  source = "../modules/eks_v2"

  providers = {
    aws = aws.us_east
  }
  cluster_name      = "${var.project}-us-east-${var.environment}"
  environment       = var.environment
  vpc_id            = data.aws_vpc.us_east.id
  app_desired_count = var.app_desired_count
  app_max_count     = var.app_max_count
  app_min_count     = var.app_min_count

  aws_auth_roles = var.aws_auth_roles
  aws_auth_users = var.aws_auth_users

  tags = local.common_tags
}
