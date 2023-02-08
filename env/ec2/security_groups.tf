resource "aws_security_group" "us_east" {
  name        = "${var.name}-sg"
  description = "ec2 instance"

  provider = aws.us_east
  vpc_id   = var.vpc_id_us_east

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "us_west" {
  name        = "${var.name}-sg"
  description = "ec2 instance"

  provider = aws.us_west
  vpc_id   = var.vpc_id_us_west

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}