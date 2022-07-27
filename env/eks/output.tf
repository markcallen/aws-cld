output "us_east_cluster_name" {
  value = module.eks_us_east.eks_cluster_name
}

output "us_east_role_arn" {
  value = module.eks_us_east.iam_role_arn
}
output "us_east_arn" {
  value = module.eks_us_east.eks_arn
}
