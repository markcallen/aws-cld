variable "json_file" {
}

locals {
  local_data = jsondecode(file(var.json_file))
}

output "project" {
  value = local.local_data.project
}

output "domain" {
  value = local.local_data.domain
}

output "backend_bucket_name" {
  value = "${local.local_data.project}-terraform"
}

output "bucket_region" {
  value = local.local_data.defaultRegion
}

