variable "cidr" {
  type = string
}
variable "name" {
  type = string
}
variable "environment" {
  type = string
}
variable "subnet_count" {
  type = number
}
variable "create_database_subnet_group" {
  default = true
}
variable "create_elasticache_subnet_group" {
  default = true
}
variable "tags" {
  type = map(any)
}
