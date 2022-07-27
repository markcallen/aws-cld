provider "aws" {
  alias  = "us_east"
  region = "us-east-2"
}

provider "aws" {
  alias  = "us_west"
  region = "us-west-2"
}

provider "kubernetes" {
  alias                  = "us_west"
  host                   = module.eks_us_west.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_us_west.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks_us_west.cluster_id]
  }
}
