data "aws_route53_zone" "zone" {
  name = "${var.environment}.${var.domain}"
}


module "us_east" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  providers = {
    aws = aws.us_east
  }
  domain_name = data.aws_route53_zone.zone.name
  zone_id     = data.aws_route53_zone.zone.zone_id

  subject_alternative_names = [
    "app.${data.aws_route53_zone.zone.name}",
    "api.${data.aws_route53_zone.zone.name}"
  ]

  wait_for_validation = true

  tags = {
    Name = data.aws_route53_zone.zone.name
  }
}

