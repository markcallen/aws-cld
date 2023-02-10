data "aws_route53_zone" "root" {
  zone_id = var.route53_zone_id
}

resource "aws_route53_record" "ec2" {
  zone_id = data.aws_route53_zone.root.zone_id
  count   = var.instance_count
  name    = "${var.project}-${count.index + 1}.${data.aws_route53_zone.root.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ec2[count.index].public_ip]
}
