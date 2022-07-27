provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "region" {
  tags = {
    Name        = "${var.region}-${var.environment}"
    Environment = var.environment
  }
}

data "aws_subnet_ids" "region" {
  vpc_id = data.aws_vpc.region.id
}

data "aws_security_group" "cnft" {
  vpc_id = data.aws_vpc.region.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/*/ubuntu-focal-20.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "host" {
  name   = "cnft-host"
  vpc_id = data.aws_vpc.region.id
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

resource "aws_security_group_rule" "ingress_app" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.host.id
}

resource "aws_security_group_rule" "ingress_web" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
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
  name   = "cnft-database"
  vpc_id = data.aws_vpc.region.id
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

resource "aws_instance" "host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "c5.xlarge"
  count         = var.instance_count
  #subnet_id                   = tolist(data.aws_subnet_ids.region.ids)[count.index]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  user_data                   = templatefile("${path.module}/host.tmpl", { ssh_keys = var.ssh_keys })

  vpc_security_group_ids = [aws_security_group.host.id, data.aws_security_group.cnft.id]

  root_block_device {
    volume_size = "50"
  }

  tags = {
    Name = "ec2-${count.index}"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

