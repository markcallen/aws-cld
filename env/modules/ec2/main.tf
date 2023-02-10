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

# Storage must be SSD, otherwise blocks are mined faster than they can be written to storage
resource "aws_ebs_volume" "data" {
  type              = "gp3"
  availability_zone = data.aws_subnet.us_east.availability_zone
  size              = var.volume_size
  iops              = var.volume_iops
  throughput        = var.volume_throughput
}

resource "aws_volume_attachment" "us_east_ebs_att" {
  device_name = var.volume_device_name
  volume_id   = aws_ebs_volume.data.id
  instance_id = aws_instance.us_east.id
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

