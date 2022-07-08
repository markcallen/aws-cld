locals {
  local_data = jsondecode(file("${path.module}/local_data.json"))
}

output "project" {
  value = local.local_data.project
}

output "backend_bucket_name" {
  value = "${local.local_data.project}-terraform"
}

output "bucket_region" {
  value = local.local_data.defaultRegion
}

