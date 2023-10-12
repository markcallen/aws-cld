variable "environment" {
  type = string
}
variable "project" {
  type = string
}
variable "region_db" {
  type = string
}
variable "region_backup" {
  type = string
}
variable "database_name" {
  type = string
}
variable "username" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "cidr_blocks" {
  type = string
}
variable "subnet_group" {
  type = string
}
variable "instance_class" {
  type    = string
  default = "db.t4g.large"
}
variable "allocated_storage" {
  type    = number
  default = 20
}
variable "max_allocated_storage" {
  type    = number
  default = 100
}
# All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
variable "database_engine" {
  type = string
}
variable "database_engine_version" {
  type = string
}
variable "database_major_engine_version" {
  type = string
}
variable "database_family" {
  type = string
}
variable "database_port" {
  type = number
}
variable "cloudwatch_logs_exports" {
  type    = list(any)
  default = ["general"]
}
