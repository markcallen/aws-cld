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

data "aws_subnets" "us_east" {
  provider = aws.us_east
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.us_east.id]
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
    values = [data.aws_vpc.us_west.id]
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

  project     = var.project
  environment = var.environment
  region      = var.region_us_east

  name             = var.name
  instance_type    = var.instance_type
  instance_count   = var.instance_count_us_east
  subnet           = data.aws_subnet.us_east
  root_disk_size   = var.root_disk_size
  extra_disk_count = var.extra_disk_count
  extra_disk_size  = var.extra_disk_size
  route53_zone_id  = var.route53_zone_id_us_east
  vpc_id           = data.aws_vpc.us_east.id
  ssh_keys         = var.ssh_keys
  tcp_ports        = var.tcp_ports
}

module "ec2_us_west" {
  source = "../modules/ec2"

  providers = {
    aws = aws.us_west
  }


  project     = var.project
  environment = var.environment
  region      = var.region_us_west

  name             = var.name
  instance_type    = var.instance_type
  instance_count   = var.instance_count_us_west
  subnet           = data.aws_subnet.us_west
  root_disk_size   = var.root_disk_size
  extra_disk_count = var.extra_disk_count
  extra_disk_size  = var.extra_disk_size
  route53_zone_id  = var.route53_zone_id_us_west
  vpc_id           = data.aws_vpc.us_west.id
  ssh_keys         = var.ssh_keys
  tcp_ports        = var.tcp_ports
}
