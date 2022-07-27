data "aws_route53_zone" "dev" {
  name = "dev.${var.domain}"
}


module "dev_us_east" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  providers = {
    aws = aws.us-east
  }
  domain_name = data.aws_route53_zone.dev.name
  zone_id     = data.aws_route53_zone.dev.zone_id

  subject_alternative_names = [
    "app.${data.aws_route53_zone.dev.name}",
    "api.${data.aws_route53_zone.dev.name}"
  ]

  wait_for_validation = true

  tags = {
    Name = data.aws_route53_zone.dev.name
  }
}
