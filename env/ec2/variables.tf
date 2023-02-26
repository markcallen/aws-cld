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

variable "route53_zone_id_us_east" {
}
variable "route53_zone_id_us_west" {
}
variable "instance_count_us_east" {
  type = number
}
variable "instance_count_us_west" {
  type = number
}
variable "extra_disk_size" {
  type = number
}
variable "extra_disk_count" {
  type = number
}
variable "ssh_keys" {
  default = []
  type    = list(any)
}
variable "instance_type" {
  type    = string
  default = "t3.small"
}
variable "root_disk_size" {
  type    = number
  default = 50
}
variable "name" {
  type = string
}

