variable "project" {
  type = string
}
variable "billing_read_users" {
  description = "List of users to add to the billing policy"
  type        = list(string)
  default     = []
}
