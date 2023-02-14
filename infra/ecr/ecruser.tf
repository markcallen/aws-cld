resource "aws_iam_policy" "eks_describe_clusters" {
  name = "${var.project}-eks-describe-clusters"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "ecr_push" {
  name = "${var.project}-ecr-push"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user" "ecruser" {
  name = "${var.project}-ecruser"

  tags = {
    name    = "ecruser"
    project = var.project
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_iam_user_policy_attachment" "eks_describe_clusters_attach" {
  user       = aws_iam_user.ecruser.name
  policy_arn = aws_iam_policy.eks_describe_clusters.arn
}

resource "aws_iam_user_policy_attachment" "ecr_push_attach" {
  user       = aws_iam_user.ecruser.name
  policy_arn = aws_iam_policy.ecr_push.arn
}
