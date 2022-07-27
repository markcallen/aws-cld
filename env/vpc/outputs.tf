output "us_west_vpc" {
#  value = {
#    "public_subnets": module.vpc_us_west.vpc.public_subnets_cidr_blocks,
#    "private_subnets": module.vpc_us_west.vpc.private_subnets_cidr_blocks,
#    "database_subnets": module.vpc_us_west.vpc.database_subnets_cidr_blocks
#  }
  value = module.vpc_us_west.vpc
}
output "us_east_vpc" {
#  value = {
#    "public_subnets": module.vpc_us_east.vpc.public_subnets_cidr_blocks,
#    "private_subnets": module.vpc_us_east.vpc.private_subnets_cidr_blocks,
#    "database_subnets": module.vpc_us_east.vpc.database_subnets_cidr_blocks
#  }
  value = module.vpc_us_east.vpc
}
