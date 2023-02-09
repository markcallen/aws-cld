data "aws_route53_zone" "us_east" {
  zone_id = var.route53_zone_id_us_east
}

data "aws_route53_zone" "us_west" {
  zone_id = var.route53_zone_id_us_west
}

resource "aws_route53_record" "ec2_us_east" {
  zone_id = data.aws_route53_zone.us_east.zone_id
  count   = var.instance_count_us_east
  name    = "${var.project}-${count.index + 1}.${data.aws_route53_zone.us_east.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.us_east[count.index].public_ip]
}

resource "aws_route53_record" "ec2_us_west" {
  zone_id = data.aws_route53_zone.us_west.zone_id
  count   = var.instance_count_us_west
  name    = "${var.project}-${count.index + 1}.${data.aws_route53_zone.us_west.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.us_west[count.index].public_ip]
}

