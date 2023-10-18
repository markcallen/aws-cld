resource "aws_iam_group_policy" "billing_read" {
  name  = "${var.project}-billing_read_policy"
  group = aws_iam_group.billing_read.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ce:Get*",
          "ce:Describe*",
          "ce:List*",
          "account:GetAccountInformation",
          "billing:Get*",
          "payments:List*",
          "payments:Get*",
          "tax:List*",
          "tax:Get*",
          "consolidatedbilling:Get*",
          "consolidatedbilling:List*",
          "invoicing:List*",
          "invoicing:Get*",
          "cur:Get*",
          "cur:Validate*",
          "freetier:Get*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_group" "billing_read" {
  name = "${var.project}-billing_read"
  path = "/"
}

resource "aws_iam_group_membership" "billing_read" {
  name  = "${var.project}-billing_read-group-membership"
  users = var.billing_read_users
  group = aws_iam_group.billing_read.name
}
