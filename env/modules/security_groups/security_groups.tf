resource "aws_security_group" "host" {
  name   = "host"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "host_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = [var.public_ip]
  security_group_id = aws_security_group.host.id
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.host.id
}

resource "aws_security_group_rule" "ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.host.id
}

resource "aws_security_group_rule" "ingress_api" {
  type              = "ingress"
  from_port         = 4000
  to_port           = 4000
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.host.id
}

resource "aws_security_group_rule" "host_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.host.id
}

resource "aws_security_group" "database" {
  name   = "database"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "database_psql" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "TCP"
  cidr_blocks       = [var.public_ip]
  security_group_id = aws_security_group.database.id
}

resource "aws_security_group_rule" "database_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.database.id
}

