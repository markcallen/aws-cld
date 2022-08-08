locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
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

  this_vpc_id = var.vpc_us_east_id
  peer_vpc_id = var.vpc_us_west_id

  auto_accept_peering = true

  tags = merge(
    local.common_tags,
    {
      Name = "us_east2us_west-${var.environment}"
    },
  )
}
