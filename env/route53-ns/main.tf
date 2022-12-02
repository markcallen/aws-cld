data "aws_route53_zone" "root" {
  name = var.domain
}

resource "aws_route53_record" "environment" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = "${var.environment}.${var.domain}"
  type    = "NS"
  ttl     = "30"
  records = var.name_servers
}
