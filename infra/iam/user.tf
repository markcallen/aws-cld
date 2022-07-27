data "local_file" "pgp_key" {
  filename = var.public_key_filename
}

resource "aws_iam_user" "user" {
  count = length(var.iam_users)
  name  = element(var.iam_users, count.index)

  tags = {
    name    = element(var.iam_users, count.index)
    project = var.project
  }
}

resource "aws_iam_user_login_profile" "login_profile" {
  count                   = length(var.iam_users)
  user                    = element(var.iam_users, count.index)
  password_reset_required = true
  pgp_key                 = data.local_file.pgp_key.content

  depends_on = [aws_iam_user.user]

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}

resource "aws_iam_user_policy_attachment" "access_keys_attach" {
  count      = length(var.iam_users)
  user       = element(var.iam_users, count.index)
  policy_arn = aws_iam_policy.access_keys.arn
}

resource "aws_iam_user_policy_attachment" "mfa_attach" {
  count      = length(var.iam_users)
  user       = element(var.iam_users, count.index)
  policy_arn = aws_iam_policy.mfa.arn
}

resource "aws_iam_group_membership" "engineering" {
  name  = "engineering-group-membership"
  users = var.eng_users
  group = aws_iam_group.engineering.name
}

resource "aws_iam_group_membership" "operations" {
  name  = "operations-group-membership"
  users = var.ops_users
  group = aws_iam_group.operations.name
}

