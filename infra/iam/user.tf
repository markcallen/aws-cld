resource "aws_iam_user" "user" {
  # Create a new user if the user_arn is not defined
  for_each = { for user, values in var.iam_users : user => values if values.terraform_managed }
  name     = each.key

  tags = {
    name    = each.key
    project = var.project
  }
}

resource "aws_iam_access_key" "user" {
  for_each = { for user, values in var.iam_users : user => values if values.cli_access }
  user     = each.key
  pgp_key  = each.value.pgp_key
}

resource "aws_iam_user_login_profile" "login_profile" {
  for_each                = { for user, values in var.iam_users : user => values if values.console_access }
  user                    = each.key
  password_reset_required = true
  pgp_key                 = each.value.pgp_key

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
  for_each   = { for user, values in var.iam_users : user => values if values.cli_access }
  user       = each.key
  policy_arn = aws_iam_policy.access_keys.arn
}

resource "aws_iam_user_policy_attachment" "mfa_attach" {
  for_each   = { for user, values in var.iam_users : user => values if values.console_access }
  user       = each.key
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
