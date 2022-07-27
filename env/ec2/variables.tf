variable "aws_region" {
}
variable "region" {
}
variable "environment" {
}
variable "cidr" {
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
variable "subnet_id" {
}
