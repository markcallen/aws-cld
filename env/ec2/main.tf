data "aws_subnets" "us_east" {
  provider = aws.us_east
  filter {
    name   = "vpc-id"
    values = [var.vpc_id_us_east]
  }

  tags = {
    Tier = "public"
  }
}

data "aws_subnet" "us_east" {
  provider = aws.us_east
  count    = length(data.aws_subnets.us_east.ids)
  id       = data.aws_subnets.us_east.ids[count.index]
}

data "aws_subnets" "us_west" {
  provider = aws.us_west
  filter {
    name   = "vpc-id"
    values = [var.vpc_id_us_west]
  }

  tags = {
    Tier = "public"
  }
}

data "aws_subnet" "us_west" {
  provider = aws.us_west
  count    = length(data.aws_subnets.us_west.ids)
  id       = data.aws_subnets.us_west.ids[count.index]
}

resource "aws_iam_role" "assume_role" {
  name = "${var.project}-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.project}-ec2-profile"
  role = aws_iam_role.assume_role.name
}


resource "aws_instance" "us_east" {
  provider = aws.us_east

  ami = data.aws_ami.us_east.id

  count = var.instance_count_us_east

  instance_type               = var.instance_type
  subnet_id                   = element(data.aws_subnet.us_east, count.index).id
  vpc_security_group_ids      = ["${aws_security_group.us_east.id}"]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.profile.name
  user_data                   = templatefile("${path.module}/host.tmpl", { ssh_keys = var.ssh_keys })

  tags = merge(
    var.additional_tags, {
      Name = var.project
  })

  root_block_device {
    volume_size = var.root_disk_size
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_instance" "us_west" {
  provider = aws.us_west

  ami = data.aws_ami.us_west.id

  count = var.instance_count_us_west

  instance_type               = var.instance_type
  subnet_id                   = element(data.aws_subnet.us_west, count.index).id
  vpc_security_group_ids      = ["${aws_security_group.us_west.id}"]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.profile.name
  user_data                   = templatefile("${path.module}/host.tmpl", { ssh_keys = var.ssh_keys })

  tags = merge(
    var.additional_tags, {
      Name = var.project
  })

  root_block_device {
    volume_size = var.root_disk_size
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

