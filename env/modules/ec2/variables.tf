variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "route53_zone_id" {
}
variable "instance_count" {
  default = "1"
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
variable "extra_disk_count" {
  type    = number
  default = 1
}
variable "extra_disk_size" {
  type    = number
  default = 100
}
variable "additional_tags" {
  type    = map(any)
  default = {}
}
