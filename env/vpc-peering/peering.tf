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
    Environment = var.environment
    Project     = var.project
  }
}

data "aws_vpc" "us_west" {
  provider = aws.us_west
  tags = {
    Name        = "${var.project}-us-west-${var.environment}"
    Environment = var.environment
    Project     = var.project
  }
}

module "us_east2us_west" {
  source  = "grem11n/vpc-peering/aws"
  version = "4.0.1"

  providers = {
    aws.this = aws.us_east
    aws.peer = aws.us_west
  }

  this_vpc_id = data.aws_vpc.us_east.id
  peer_vpc_id = data.aws_vpc.us_west.id

  auto_accept_peering = true

  tags = merge(
    local.common_tags,
    {
      Name = "us_east2us_west-${var.environment}"
    },
  )
}
