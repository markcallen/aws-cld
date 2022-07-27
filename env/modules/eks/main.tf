data "aws_vpc" "region" {
  id = var.vpc_id
}

data "aws_subnet_ids" "region" {
  vpc_id = var.vpc_id
}

data "aws_subnet_ids" "node_region" {
  vpc_id = var.vpc_id

  tags = {
    Tier = "public"
  }  
}
