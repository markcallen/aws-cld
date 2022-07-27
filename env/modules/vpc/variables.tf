variable "cidr" {
}
variable "name" {
}
variable "environment" {
}
variable "subnet_count" {
}
variable "create_database_subnet_group" {
  default = true
}
variable "tags" {
  type = map(any)
}
