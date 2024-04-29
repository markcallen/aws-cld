resource "aws_iam_policy" "rekognition" {
  name        = "rekognition-policy-${local.name}"
  description = format("Allow rekognition to manage route53 resources")
  path        = "/"
  policy      = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "rekognitionPolicies",
          "Effect": "Allow",
          "Action": [
              "rekognition:*"
          ],
          "Resource": "*"
      },
      {
          "Sid": "groundTruthPolicies",
          "Effect": "Allow",
          "Action": [
              "groundtruthlabeling:*"
          ],
          "Resource": "*"
      }
  ]
}
EOT
}

resource "aws_iam_role" "rekognition_irsa" {
  name = "rekognition-irsa-${local.name}"
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

resource "aws_iam_role_policy_attachment" "rekognition_irsa_attachment" {
  policy_arn = aws_iam_policy.rekognition.arn
  role       = aws_iam_role.rekognition_irsa.name
}
