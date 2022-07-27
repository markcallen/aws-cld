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

module "security_group_database_us_east" {
  source = "../modules/security_groups/database"

  providers = {
    aws = aws.us_east
  }
  vpc_id = data.aws_vpc.us_east.id
}

module "security_group_database_us_west" {
  source = "../modules/security_groups/database"

  providers = {
    aws = aws.us_west
  }
  vpc_id = data.aws_vpc.us_west.id
}
