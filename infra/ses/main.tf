locals {
  common_tags = {
    Environment = "infra"
    ManagedBy   = "aws-cld"
    Project     = var.project
  }

  username   = var.username != "" ? var.username : "${var.project}-ses"
  group_name = "${var.project}-ses-group"
}

resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.domain
}

resource "aws_ses_email_identity" "ses_identity" {
  email = var.email
}

resource "aws_ses_domain_dkim" "dkim" {
  domain = aws_ses_domain_identity.ses_domain.domain
}

data "aws_iam_policy_document" "ses_policy" {
  statement {
    actions   = ["ses:SendRawEmail", "ses:SendEmail"]
    resources = ["*"]
  }
}

resource "aws_iam_group" "ses_users" {
  name = local.group_name
  path = "/"
}

resource "aws_iam_group_policy" "ses_group_policy" {
  name  = "${var.project}-ses-group-policy"
  group = aws_iam_group.ses_users.name

  policy = data.aws_iam_policy_document.ses_policy.json
}

resource "aws_iam_user" "ses_user" {
  name = local.username

  tags = local.common_tags
}

resource "aws_iam_access_key" "ses_access_key" {
  user = aws_iam_user.ses_user.name
}

resource "aws_iam_user_group_membership" "ses_user" {
  user = aws_iam_user.ses_user.name

  groups = [
    aws_iam_group.ses_users.name
  ]
}
