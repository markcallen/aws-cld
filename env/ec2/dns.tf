data "aws_route53_zone" "region" {
  name         = "${var.region}.${var.environment}.nval.com."
  private_zone = false
}

data "aws_route53_zone" "environment" {
  name         = "${var.environment}.nval.com."
  private_zone = false
}

resource "aws_route53_record" "ec2" {
  zone_id = data.aws_route53_zone.region.zone_id
  count   = var.instance_count
  name    = "ec2-${count.index + 1}.${data.aws_route53_zone.region.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.host[count.index].public_ip]
}

