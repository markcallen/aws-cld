variable "environment" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "cluster_version" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "app_desired_count" {
  type = number
}
variable "app_max_count" {
  type = number
}
variable "app_min_count" {
  type = number
}
variable "enable" {
  type    = number
  default = 1
}
variable "aws_auth_roles" {
  type = list(any)
}
variable "aws_auth_users" {
  type = list(any)
}
variable "tags" {
  type = map(any)
}
variable "secrets" {
  type = list(any)
}
variable "s3_buckets" {
  type = list(any)
}
