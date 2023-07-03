data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = var.name
  cidr = var.cidr

  azs = data.aws_availability_zones.available.names
  public_subnets = [
    for num in range(1, var.subnet_count + 1) :
    cidrsubnet(var.cidr, 8, num)
  ]
  private_subnets = [
    for num in range(201, var.subnet_count + 201) :
    cidrsubnet(var.cidr, 8, num)
  ]
  database_subnets = [
    for num in range(101, var.subnet_count + 101) :
    cidrsubnet(var.cidr, 8, num)
  ]
  elasticache_subnets = [
    for num in range(151, var.subnet_count + 151) :
    cidrsubnet(var.cidr, 8, num)
  ]

  private_subnet_tags = {
    "Tier" : "private"
    "kubernetes.io/role/internal-elb" : 1
    "kubernetes.io/cluster/${var.name}" : "shared"
  }

  public_subnet_tags = {
    "Tier" : "public"
    "kubernetes.io/role/elb" : 1
    "kubernetes.io/cluster/${var.name}" : "shared"
  }

  database_subnet_tags = {
    "Tier" : "database"
  }

  elasticache_subnet_tags = {
    "Tier" : "elasticache"
  }

  create_database_subnet_group    = var.create_database_subnet_group
  create_elasticache_subnet_group = var.create_elasticache_subnet_group

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = merge(
    var.tags,
    {
      Name = var.name
    },
  )
}
