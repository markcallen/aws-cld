resource "aws_instance" "ec2" {
  ami = var.ami_id

  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true
  iam_instance_profile        = var.profile_name
  user_data                   = templatefile("${path.module}/host.tmpl", { ssh_keys = var.ssh_keys })

  tags = merge(
    var.additional_tags, {
      Name = var.name
  })

  root_block_device {
    volume_size = var.root_disk_size
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

# Storage must be SSD, otherwise blocks are mined faster than they can be written to storage
resource "aws_ebs_volume" "extra_disk" {
  count = var.extra_disk_count

  type              = var.extra_disk_type
  availability_zone = var.availability_zone
  size              = var.extra_disk_size
  iops              = var.extra_disk_iops
  throughput        = var.extra_disk_throughput
}

resource "aws_volume_attachment" "ebs_att" {
  count = var.extra_disk_count

  device_name = var.extra_disk_device_names[count.index]
  volume_id   = aws_ebs_volume.extra_disk[count.index].id
  instance_id = aws_instance.ec2.id
}

