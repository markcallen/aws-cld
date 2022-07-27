module "eks_security_group" {
  source = "../security_groups/eks"

  eks_cluster_name = var.eks_cluster_name
  public_ip = var.public_ip
  environment = var.environment
  vpc_id = var.vpc_id
}
