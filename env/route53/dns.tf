locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "aws-cloud"
    Project     = var.project
  }
}

resource "aws_route53_zone" "root" {
  name = "${var.environment}.${var.domain}"

  tags = local.common_tags
}

resource "aws_route53_zone" "us_west" {
  name = "us-west.${var.environment}.${var.domain}"

  tags = local.common_tags
}

resource "aws_route53_record" "us_west_ns" {
  zone_id = aws_route53_zone.root.zone_id
  name    = "us-west.${var.environment}.${var.domain}"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.us_west.name_servers
}

resource "aws_route53_zone" "us_east" {
  name = "us-east.${var.environment}.${var.domain}"

  tags = local.common_tags
}

resource "aws_route53_record" "us_east_ns" {
  zone_id = aws_route53_zone.root.zone_id
  name    = "us-east.${var.environment}.${var.domain}"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.us_east.name_servers
}
