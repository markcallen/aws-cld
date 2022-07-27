data "aws_vpc" "us_east" {
  provider = aws.us_east

  tags = {
    Name        = "us-east-${var.environment}"
    Environment = var.environment
  }
}

data "aws_vpc" "us_west" {
  provider = aws.us_west

  tags = {
    Name        = "us-west-${var.environment}"
    Environment = var.environment
  }
}

module "eks_us_east" {
  source = "../modules/eks_v2"

  providers = {
    aws = aws.us_east
  }
  cluster_name      = "nval-us-east-${var.environment}"
  environment       = var.environment
  vpc_id            = data.aws_vpc.us_east.id
  app_desired_count = var.app_desired_count
  app_max_count     = var.app_max_count
  app_min_count     = var.app_min_count
}
