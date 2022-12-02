locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "aws-cloud"
    Project     = var.project
  }
}

module "us_east2us_west" {
  source  = "grem11n/vpc-peering/aws"
  version = "4.1.0"

  providers = {
    aws.this = aws.us_east
    aws.peer = aws.us_west
  }

  this_vpc_id = var.vpc_id_us_east
  peer_vpc_id = var.vpc_id_us_west

  auto_accept_peering = true

  tags = merge(
    local.common_tags,
    {
      Name = "us_east2us_west-${var.environment}"
    },
  )
}
