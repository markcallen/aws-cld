variable "aws_region" {
  default = "us-east-1"
}
variable "ops_iam_policy" {
  description = "IAM Policy to be attached to operations role"
  type        = list(string)
}
variable "eng_iam_policy" {
  description = "IAM Policy to be attached to engineering role"
  type        = list(string)
}
