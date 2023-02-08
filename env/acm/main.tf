locals {
  common_tags = {
    Environment     = var.environment
    EnvironmentName = var.environment_name
    ManagedBy       = "aws-cld"
    Project         = var.project
  }
}

data "aws_route53_zone" "environment" {
  name = "${var.environment_name}.${var.domain}"
}

module "us_east" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  providers = {
    aws = aws.us_east
  }

  domain_name = data.aws_route53_zone.environment.name
  zone_id     = data.aws_route53_zone.environment.zone_id

  subject_alternative_names = var.subject_alternative_names

  wait_for_validation = true

  tags = merge({
    Name   = data.aws_route53_zone.environment.name
    Region = var.region_us_east
  }, local.common_tags)
}

module "us_west" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  providers = {
    aws = aws.us_west
  }

  domain_name = data.aws_route53_zone.environment.name
  zone_id     = data.aws_route53_zone.environment.zone_id

  subject_alternative_names = var.subject_alternative_names

  wait_for_validation = true

  tags = merge({
    Name   = data.aws_route53_zone.environment.name
    Region = var.region_us_west
  }, local.common_tags)
}
