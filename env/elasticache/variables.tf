variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "region_us_east" {
  type = string
}
variable "region_us_west" {
  type = string
}
variable "node_type" {
  default = "cache.m6g.large"
}
variable "vpc_us_east_id" {
}
variable "vpc_us_west_id" {
}
variable "subnet_group_us_east_name" {
}
variable "subnet_group_us_west_name" {
}
