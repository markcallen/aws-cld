data "aws_secretsmanager_secret" "nval-web-app" {
  name = "${var.environment}.nval-web-app"
}

data "aws_secretsmanager_secret" "nval-rest-api" {
  name = "${var.environment}.nval-rest-api"
}

data "aws_secretsmanager_secret" "ltf-model" {
  name = "${var.environment}.ltf-model"
}


#########################Secret Manager Polices #####################
resource "aws_iam_policy" "secretsmanager" {
  name        = "secretsmanager-policy-${local.name}"
  description = format("Allow secrets-store-csi-driver-provider-aws to manage AWS resources")
  path        = "/"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [ {
        "Effect": "Allow",
        "Action": ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"],
        "Resource": ["${data.aws_secretsmanager_secret.nval-web-app.id}","${data.aws_secretsmanager_secret.nval-rest-api.id}","${data.aws_secretsmanager_secret.ltf-model.id}"]
    } ]

}
EOT
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
        StringEquals = {
          "${module.eks.oidc_provider}:sub" = ["system:serviceaccount:nval-app:nval-web-app", "system:serviceaccount:nval-app:nval-rest-api", "system:serviceaccount:nval-app:ltf-model", "system:serviceaccount:nval-app:nval-ltf-model"]
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
