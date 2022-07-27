variable "eks_cluster_name" {
  type = string
}
variable "vpc_id" {
}
variable "public_ip" {
  description = "The public ip for the current machine"
  default     = "0.0.0.0/0"
}
variable "environment" {
}
variable "oidc_thumbprint_list" {
  type    = list(any)
  default = []
}
variable "app_desired_count" {
}
variable "app_max_count" {
}
variable "app_min_count" {
}
