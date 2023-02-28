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
}
variable "route53_zone_id" {
}
variable "subnet" {
}
variable "root_disk_size" {
}
variable "extra_disk_size" {
}
variable "extra_disk_count" {
}
variable "instance_type" {
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
