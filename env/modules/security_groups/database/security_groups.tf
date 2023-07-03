resource "aws_security_group" "database" {
  name   = "database"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "database_mysql" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "TCP"
  cidr_blocks       = [var.public_ip]
  security_group_id = aws_security_group.database.id
}

resource "aws_security_group_rule" "database_posgresql" {
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
