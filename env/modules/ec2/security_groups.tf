resource "aws_security_group" "ssh_web" {
  name        = "${var.name}-${random_id.id.hex}-ec2-sg-${var.region}"
  description = "ec2 instance"

  vpc_id = var.vpc_id

  ingress {
    description = "ssh port 22 ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http port 80 ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https port 443 ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "global egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      name
    ]
  }
}

resource "aws_security_group_rule" "tcp_ports" {
  count             = length(var.tcp_ports)
  type              = "ingress"
  to_port           = var.tcp_ports[count.index]
  from_port         = var.tcp_ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ssh_web.id
}
