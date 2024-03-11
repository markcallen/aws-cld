locals {
  s3_directories = [for d in var.s3_buckets : "${d}/*"]
}

resource "aws_iam_policy" "s3" {
  name        = "s3-policy-${local.name}"
  description = format("Allow access to s3")
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:ListBucket"]
      Resource = var.s3_buckets
      }, {
      Effect = "Allow"
      Action = ["s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetObjectAcl",
        "s3:DeleteObject"
      ],
      Resource = local.s3_directories
    }]
  })
}

resource "aws_iam_role" "s3_irsa" {
  name = "s3-irsa-${local.name}"
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

resource "aws_iam_role_policy_attachment" "s3_irsa_attachment" {
  policy_arn = aws_iam_policy.s3.arn
  role       = aws_iam_role.s3_irsa.name
}
