resource "aws_eks_cluster" "main" {
  name            = var.eks_cluster_name
  role_arn        = aws_iam_role.cluster.arn

  vpc_config {
    security_group_ids = [module.eks_security_group.cluster.id]
    subnet_ids         = data.aws_subnet_ids.region.ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
  ]

  tags = {
    Environment = var.environment
  }
}

data "tls_certificate" "main" {
  url = aws_eks_cluster.main.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "main" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.tls_certificate.main.certificates.0.sha1_fingerprint], var.oidc_thumbprint_list)
  url = aws_eks_cluster.main.identity.0.oidc.0.issuer
}
