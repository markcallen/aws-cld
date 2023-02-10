data "aws_subnets" "us_east" {
  provider = aws.us_east
  filter {
    name   = "vpc-id"
    values = [var.vpc_id_us_east]
  }

  tags = {
    Tier = "public"
  }
}

data "aws_subnet" "us_east" {
  provider = aws.us_east
  count    = length(data.aws_subnets.us_east.ids)
  id       = data.aws_subnets.us_east.ids[count.index]
}

data "aws_subnets" "us_west" {
  provider = aws.us_west
  filter {
    name   = "vpc-id"
    values = [var.vpc_id_us_west]
  }

  tags = {
    Tier = "public"
  }
}

data "aws_subnet" "us_west" {
  provider = aws.us_west
  count    = length(data.aws_subnets.us_west.ids)
  id       = data.aws_subnets.us_west.ids[count.index]
}

module "ec2_us_east" {
  source = "../modules/ec2"

  providers = {
    aws = aws.us_east
  }

  subnets = data.aws_subnets.us_east
}
