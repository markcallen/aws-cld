variable "environment" {
}

variable "project" {
}

variable "public_ip" {
  default = "0.0.0.0/0"
}

variable "app_desired_count" {
}

variable "app_max_count" {
}

variable "app_min_count" {
}

variable "region_us_east" {
  type = string
}
variable "region_us_west" {
  type = string
}

variable "aws_auth_roles" {
  type    = list(any)
  default = []
}

variable "aws_auth_users" {
  type    = list(any)
  default = []
}
