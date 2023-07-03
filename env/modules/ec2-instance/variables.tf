variable "ami_id" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "profile_name" {
  type = string
}
variable "instance_type" {
  type    = string
  default = "t3.small"
}
variable "root_disk_size" {
  description = "size in GB"
  type        = number
  default     = 20
}
variable "root_disk_type" {
  type    = string
  default = "gp2"
}
variable "root_disk_iops" {
  type    = number
  default = 0
}
variable "root_disk_throughput" {
  type    = number
  default = 0
}
variable "extra_disk_count" {
  type    = number
  default = 1
}
variable "extra_disk_size" {
  description = "size in GB"
  type        = number
  default     = 100
}
variable "extra_disk_type" {
  type    = string
  default = "gp3"
}
variable "extra_disk_iops" {
  type    = number
  default = 3000
}
variable "extra_disk_throughput" {
  type    = number
  default = 125
}
variable "extra_disk_device_names" {
  type    = list(any)
  default = ["/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg"]
}
variable "security_group_ids" {
  type = list(any)
}
variable "availability_zone" {
  type = string
}
variable "additional_tags" {
  type    = map(any)
  default = {}
}
variable "ssh_keys" {
  default = []
  type    = list(any)
}
variable "name" {
  type = string
}
