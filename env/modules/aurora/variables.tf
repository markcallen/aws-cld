variable "environment" {
  type = string
}
variable "database_engine" {
  type = string
}
variable "database_engine_version" {
  type = string
}
variable "database_name" {
  type = string
}
variable "rds_master_username" {
  type = string
}
variable "rds_master_password" {
  type = string
}
variable "subnet_count_us_east" {
  type = number
}
variable "subnet_count_us_west" {
  type = number
}
variable "instance_class" {
  type = string
}
variable "db_subnet_us_east" {
  type = string
}
variable "db_subnet_us_west" {
  type = string
}
variable "vpc_security_group_us_east" {
  type = string
}
variable "vpc_security_group_us_west" {
  type = string
}
