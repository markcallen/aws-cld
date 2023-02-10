resource "aws_iam_role" "assume_role" {
  name = "${var.project}-ec2-role-${var.region}"

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
  name = "${var.project}-ec2-profile-${var.region}"
  role = aws_iam_role.assume_role.name
}

module "ec2_instance" {
  source = "../ec2-instance"

  count = var.instance_count

  project     = var.project
  environment = var.environment

  ami_id             = data.aws_ami.ubuntu2004.id
  profile_name       = aws_iam_instance_profile.profile.name
  instance_type      = var.instance_type
  subnet_id          = element(var.subnet, count.index).id
  root_disk_size     = var.root_disk_size
  security_group_ids = [aws_security_group.ssh_web.id]
  availability_zone  = element(var.subnet, count.index).availability_zone
  ssh_keys           = var.ssh_keys
  extra_disk_size    = var.extra_disk_size
}
