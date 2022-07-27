output "eks_cluster_name" {
  value = var.eks_cluster_name
}

output "eks_arn" {
  value = aws_eks_cluster.main.arn
}

output "iam_role_arn" {
  value = aws_iam_role.cluster.arn
}

output "openid_connect_url" {
  value = aws_iam_openid_connect_provider.main.url
}

output "openid_connect_arn" {
  value = aws_iam_openid_connect_provider.main.arn
}

output "eks_alb_ingress_controller_arn" {
  value = aws_iam_role.eks_alb_ingress_controller.arn
}
