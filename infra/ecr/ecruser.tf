/*
 resource "aws_iam_policy" "assume_role_eks" {
  name = "assume-role-eks"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:iam::421566961691:role/us-east-dev-cluster",
          "arn:aws:iam::421566961691:role/us-east-stage-cluster",
          "arn:aws:iam::421566961691:role/us-east-prod-cluster",
          "arn:aws:iam::421566961691:role/nval-us-east-stage-cluster-20220603213847059100000009",
          "arn:aws:iam::421566961691:role/nval-us-east-dev-cluster-20220620205454022200000009",
          "arn:aws:iam::421566961691:role/nval-us-east-prod-cluster-20220617225441184800000009"
        ]
      },
    ]
  })
}
*/

resource "aws_iam_policy" "eks_describe_clusters" {
  name = "eks-describe-clusters"
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
  name = "ecr-push"
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
  name = "${module.local.project}-ecruser"

  tags = {
    name    = "ecruser"
    project = module.local.project
  }
}

/*
resource "aws_iam_user_policy_attachment" "assume_role_eks_attach" {
  user       = aws_iam_user.ecruser.name
  policy_arn = aws_iam_policy.assume_role_eks.arn
}
*/

resource "aws_iam_user_policy_attachment" "eks_describe_clusters_attach" {
  user       = aws_iam_user.ecruser.name
  policy_arn = aws_iam_policy.eks_describe_clusters.arn
}

resource "aws_iam_user_policy_attachment" "ecr_push_attach" {
  user       = aws_iam_user.ecruser.name
  policy_arn = aws_iam_policy.ecr_push.arn
}
