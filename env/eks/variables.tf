variable "environment" {
  type = string
}
variable "project" {
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
variable "region_us_east" {
  type = string
}
variable "region_us_west" {
  type = string
}
variable "enable_us_east" {
  type    = number
  default = 1
}
#variable "enable_us_west" {
#  type    = number
#  default = 1
#}
variable "aws_auth_roles" {
  type    = list(any)
  default = []
}
variable "aws_auth_users" {
  type    = list(any)
  default = []
}
