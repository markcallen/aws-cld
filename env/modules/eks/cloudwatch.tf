resource "aws_iam_policy" "cloudwatch" {
  name        = "cloudwatch-policy-${local.name}"
  description = format("Allow cluster-cloudwatch to manage AWS resources")
  path        = "/"
  policy      = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "logs",
            "Effect": "Allow",
            "Action": [
              "logs:putRetentionPolicy",
              "logs:CreateLogStream",
              "logs:CreateLogGroup",
              "logs:PutLogEvents",
              "logs:DescribeLogGroups",
              "logs:DescribeLogStreams"
            ],
            "Resource": [
              "*"
            ]
        }
    ]
}
EOT
}

resource "aws_iam_role" "cloudwatch_irsa" {
  name = "cloudwatch-irsa-${local.name}"
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

resource "aws_iam_role_policy_attachment" "cloudwatch_irsa_attachment" {
  policy_arn = aws_iam_policy.cloudwatch.arn
  role       = aws_iam_role.cloudwatch_irsa.name
}
