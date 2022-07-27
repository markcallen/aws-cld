variable "eks_cluster_name" {
}
variable "vpc_id" {
}
variable "environment" {
}
variable "public_ip" {
  description = "The public ip for the current machine"
  default     = "0.0.0.0/0"
}
