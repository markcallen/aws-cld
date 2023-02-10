variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "ami_id" {
}
variable "subnet_id" {
}
variable "profile_name" {
}
variable "instance_type" {
  default = "t3.small"
}
variable "root_disk_size" {
  type    = number
  default = 20
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
variable "extra_disk_iops" {
  default = 3000
}

variable "extra_disk_throughput" {
  default = 125
}

variable "extra_disk_type" {
  type    = string
  default = "gp3"
}

variable "extra_disk_device_names" {
  type    = list(any)
  default = ["/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg"]
}
variable "security_group_ids" {
  type = list(any)
}
variable "availability_zone" {
}
variable "additional_tags" {
  type    = map(any)
  default = {}
}
variable "ssh_keys" {
  default = []
  type    = list(any)
}
