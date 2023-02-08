locals {
  common_tags = {
    Environment     = var.environment
    EnvironmentName = var.environment_name
    ManagedBy       = "aws-cld"
    Project         = var.project
  }
}

resource "aws_route53_zone" "environment" {
  name = "${var.environment_name}.${var.domain}"

  tags = local.common_tags
}

resource "aws_route53_zone" "us_west" {
  name = "usw.${var.environment_name}.${var.domain}"

  tags = local.common_tags
}

resource "aws_route53_record" "us_west_ns" {
  zone_id = aws_route53_zone.environment.zone_id
  name    = "usw.${var.environment_name}.${var.domain}"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.us_west.name_servers
}

resource "aws_route53_zone" "us_east" {
  name = "use.${var.environment_name}.${var.domain}"

  tags = local.common_tags
}

resource "aws_route53_record" "us_east_ns" {
  zone_id = aws_route53_zone.environment.zone_id
  name    = "use.${var.environment_name}.${var.domain}"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.us_east.name_servers
}
