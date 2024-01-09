variable "environment" {
  type = string
}
variable "secrets" {
  description = "List of the secrets"
  type        = list(string)
}
variable "tags" {
  type = map(any)
}
