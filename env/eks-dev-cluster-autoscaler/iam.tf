provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_policy" "cluster-autoscaler_policy" {
  name        = "${var.environment}-cluster-autoscaler_policy"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeInstanceTypes",
        "eks:DescribeNodegroup"
      ],
      "Resource": ["*"]
    }
  ]
}
EOT
}

resource "aws_iam_policy" "cluster-autoscaler_s3_policy" {
  name        = "${var.environment}-cluster-autoscaler_s3_policy"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::my-pod-secrets-bucket/*"
      ]
    }
  ]
}
EOT
}

data "aws_eks_cluster" "cluster_name" {
  name = "${var.cluster_name}"
}
output "identity-oidc-issuer" {
  value = "${data.aws_eks_cluster.cluster_name.identity.0.oidc.0.issuer}"
}
data "aws_iam_openid_connect_provider" "oidc-arn" {
  url = "${data.aws_eks_cluster.cluster_name.identity.0.oidc.0.issuer}"
}


module "iam_eks_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "${var.environment}-nval-cluster-autoscaler"

  oidc_providers = {
    one = {
      provider_arn               = "${data.aws_iam_openid_connect_provider.oidc-arn.id}"
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]

    }
  }
}

resource "aws_iam_role_policy_attachment" "cluster-autoscaler_policy" {
  policy_arn = aws_iam_policy.cluster-autoscaler_policy.arn
  role       = "${var.environment}-nval-cluster-autoscaler"
}

resource "aws_iam_role_policy_attachment" "cluster-autoscaler_s3_policy" {
  policy_arn = aws_iam_policy.cluster-autoscaler_s3_policy.arn
  role       = "${var.environment}-nval-cluster-autoscaler"
}

resource "aws_iam_policy" "cluster-autodiscovery_policy" {
  name        = "${var.environment}-cluster-autodiscovery_policy"

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:DescribeTags",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": ["*"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": ["*"]
        }
    ]
}
EOT
}

data "aws_iam_role" "node-role" {
  name = "us-east-${var.environment}-node"
}

resource "aws_iam_role_policy_attachment" "cluster-autodiscovery_policy" {
  policy_arn = aws_iam_policy.cluster-autodiscovery_policy.id
  role       = "${data.aws_iam_role.node-role.id}"
}

