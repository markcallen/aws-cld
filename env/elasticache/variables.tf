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
  type    = string
  default = "cache.m6g.large"
}
variable "vpc_us_east_id" {
  type = string
}
variable "vpc_us_west_id" {
  type = string
}
