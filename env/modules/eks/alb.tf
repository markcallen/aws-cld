data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.main.url}:sub"
      values   = ["system:serviceaccount:kube-system:alb-ingress-controller"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.main.arn]
      type        = "Federated"
    }
  }
}

data "http" "alb_iam_policy_json" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.6/docs/examples/iam-policy.json"
 request_headers = {
    Accept = "application/json"
  }
}

data "aws_iam_policy_document" "eks_alb_ingress_controller" {
  source_json = data.http.alb_iam_policy_json.body
}

resource "aws_iam_policy" "ALBIngressControllerIAMPolicy" {
  name        = "ALBIngressControllerIAMPolicy-${var.eks_cluster_name}"
  path        = "/"
  policy = data.aws_iam_policy_document.eks_alb_ingress_controller.json
}

resource "aws_iam_role" "eks_alb_ingress_controller" {
  name               = "eks-alb-ingress-controller-${var.eks_cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cluster_ALBIngressControllerIAMPolicy" {
  policy_arn = aws_iam_policy.ALBIngressControllerIAMPolicy.arn
  role       = aws_iam_role.eks_alb_ingress_controller.name
}

resource "aws_iam_policy" "ALBIngressControllerRoute53Policy" {
  name        = "ALBIngressControllerRoute53Policy-${var.eks_cluster_name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ALBIngressControllerRoute53Policy" {
  policy_arn = aws_iam_policy.ALBIngressControllerRoute53Policy.arn
  role       = aws_iam_role.eks_alb_ingress_controller.name
}
