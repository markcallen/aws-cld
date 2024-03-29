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
variable "secrets" {
  description = "List of the secrets"
  type        = list(string)
}
