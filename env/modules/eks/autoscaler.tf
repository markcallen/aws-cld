resource "aws_iam_policy" "autoscaler" {
  name        = "autoscaler-policy-${local.name}"
  description = format("Allow cluster-autoscaler to manage AWS resources")
  path        = "/"
  policy      = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/k8s.io/cluster-autoscaler/${local.name}": "owned"
                }
            }
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeAutoScalingGroups",
                "ec2:DescribeLaunchTemplateVersions",
                "autoscaling:DescribeTags",
                "autoscaling:DescribeLaunchConfigurations"
            ],
            "Resource": "*"
        }
    ]
}
EOT
}

resource "aws_iam_role" "autoscaler_irsa" {
  name = "autoscaler-irsa-${local.name}"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = module.eks.oidc_provider_arn
      }
      Condition = {
        StringEquals = {
          "${module.eks.oidc_provider}:sub" = "system:serviceaccount:${local.namespace}:cluster-autoscaler"
        }
      }
    }]
    Version = "2012-10-17"
  })
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "autoscaler_irsa_attachment" {
  policy_arn = aws_iam_policy.autoscaler.arn
  role       = aws_iam_role.autoscaler_irsa.name
}
