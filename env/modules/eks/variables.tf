variable "cluster_name" {
  type = string
}

variable "vpc_id" {
}

variable "environment" {
}

variable "app_desired_count" {
}

variable "app_max_count" {
}

variable "app_min_count" {
}
variable "enable" {
  type    = number
  default = 1
}

variable "aws_auth_roles" {
  type    = list(any)
  default = []
}

variable "aws_auth_users" {
  type    = list(any)
  default = []
}

variable "tags" {
  type = map(any)
}
