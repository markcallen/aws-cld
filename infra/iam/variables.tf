variable "project" {
  type = string
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "ops_iam_policy" {
  description = "IAM Policy to be attached to operations role"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53DomainsFullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
  ]
}
variable "eng_iam_policy" {
  description = "IAM Policy to be attached to engineering role"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonVPCReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53DomainsReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  ]
}

# Example
# iam_users = {
#   mark = {
#     terraform_managed = true
#     console_access = false
#     cli_access = true
#     pgp_key = "keybase:markcallen"
#   }
# }
#
variable "iam_users" {
  description = "List of users to create in IAM"
  type = map(object({
    terraform_managed = bool
    console_access    = bool
    cli_access        = bool
    pgp_key           = string
  }))
  default = {}
}

variable "eng_users" {
  description = "IAM users be in the eng group with the eng policies"
  type        = list(string)
  default     = []
}

variable "ops_users" {
  description = "IAM users be in the ops group with the ops policies"
  type        = list(string)
  default     = []
}
