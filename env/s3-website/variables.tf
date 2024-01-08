variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "bucket_name" {
  type = string
}
variable "allowed_origins" {
  type = list(string)
}

