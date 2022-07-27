variable "project" {
  type = string
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "ecr_repositories" {
  description = "List of the ECR repositories"
  type        = list(string)
}

