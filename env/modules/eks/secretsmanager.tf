data "aws_secretsmanager_secret" "secrets" {
  count = length(var.secrets)
  name  = "${var.environment}/${element(var.secrets, count.index)}"
}

#########################Secret Manager Polices #####################
resource "aws_iam_policy" "secretsmanager" {
  name        = "secretsmanager-policy-${local.name}"
  description = format("Allow secrets-store-csi-driver-provider-aws to manage AWS resources")
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
      Resource = data.aws_secretsmanager_secret.secrets[*].id
    }]
  })
}

resource "aws_iam_role" "secretsmanager_irsa" {
  name = "secretsmanager-irsa-${local.name}"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = module.eks.oidc_provider_arn
      }
      Condition = {
        StringLike = {
          "${module.eks.oidc_provider}:sub" = ["system:serviceaccount:*:*"]
        }
      }
    }]
    Version = "2012-10-17"
  })
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "secretsmanager_irsa_attachment" {
  policy_arn = aws_iam_policy.secretsmanager.arn
  role       = aws_iam_role.secretsmanager_irsa.name
}
