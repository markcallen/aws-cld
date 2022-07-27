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
variable "cidr" {
  type = map(any)
}
variable "subnet_count" {
  type = number
}
