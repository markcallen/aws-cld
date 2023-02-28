variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "region" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "route53_zone_id" {
  type = string
}
variable "subnet" {
  type = list(any)
}
variable "root_disk_size" {
  type = number
}
variable "extra_disk_size" {
  type = number
}
variable "extra_disk_count" {
  type = number
}
variable "instance_type" {
  type = string
}
variable "instance_count" {
  type    = number
  default = 1
}
variable "ssh_keys" {
  default = []
  type    = list(any)
}
variable "public_ip" {
  type    = string
  default = "0.0.0.0/0"
}
variable "name" {
  type = string
}
variable "additional_tags" {
  type    = map(any)
  default = {}
}
variable "tcp_ports" {
  type    = list(any)
  default = []
}
