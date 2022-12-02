variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "name" {
  type = string
}
variable "region_us_east" {
  type = string
}
variable "region_us_west" {
  type = string
}
variable "vpc_id_us_east" {
  type = string
}
variable "vpc_id_us_west" {
  type = string
}
variable "route53_zone_id_us_east" {
}
variable "route53_zone_id_us_west" {
}
variable "instance_count_us_east" {
  default = "1"
}
variable "instance_count_us_west" {
  default = "0"
}
variable "ssh_keys" {
  default = []
  type    = list(any)
}
variable "public_ip" {
  default = "0.0.0.0/0"
}
variable "instance_type" {
  default = "t3.small"
}
variable "root_disk_size" {
  type    = number
  default = 20
}
variable "additional_tags" {
  type    = map(any)
  default = {}
}
