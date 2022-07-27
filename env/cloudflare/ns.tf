data "aws_route53_zone" "root" {
  name = "${var.environment}.${var.domain}"
}

resource "cloudflare_record" "aws-ns-record" {
  zone_id  = var.zone_id
  count    = length(data.aws_route53_zone.root.name_servers)
  name     = var.environment
  value    = element(data.aws_route53_zone.root.name_servers, count.index)
  type     = "NS"
  priority = 1
}
