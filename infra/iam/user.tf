module "local" {
  source = "../../local"
}

data "local_file" "pgp_key" {
  filename = "./public-key.gpg"
}

resource "aws_iam_user" "user" {
  count = length(module.local.iam_users)
  name  = element(module.local.iam_users, count.index)

  tags = {
    name    = element(module.local.iam_users, count.index)
    project = module.local.project
  }
}

resource "aws_iam_user_login_profile" "login_profile" {
  count                   = length(module.local.iam_users)
  user                    = element(module.local.iam_users, count.index)
  password_reset_required = true
  pgp_key                 = data.local_file.pgp_key.content

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}

resource "aws_iam_user_policy_attachment" "access_keys_attach" {
  count      = length(module.local.iam_users)
  user       = element(module.local.iam_users, count.index)
  policy_arn = aws_iam_policy.access_keys.arn
}

resource "aws_iam_user_policy_attachment" "mfa_attach" {
  count      = length(module.local.iam_users)
  user       = element(module.local.iam_users, count.index)
  policy_arn = aws_iam_policy.mfa.arn
}

resource "aws_iam_group_membership" "engineering" {
  name  = "engineering-group-membership"
  users = module.local.eng_users
  group = aws_iam_group.engineering.name
}

resource "aws_iam_group_membership" "operations" {
  name  = "operations-group-membership"
  users = module.local.ops_users
  group = aws_iam_group.operations.name
}

