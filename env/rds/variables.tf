variable "environment" {
}
variable "project" {
}
variable "region_db" {
  type = string
}
variable "region_backup" {
  type = string
}
variable "database_name" {
}
variable "username" {
}
variable "vpc_id" {
}
variable "cidr_blocks" {
}
variable "subnet_group" {
}
variable "instance_class" {
  default = "db.t4g.large"
}
variable "allocated_storage" {
  default = 20
}
