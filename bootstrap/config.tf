resource "local_file" "infra_backend" {
  content = templatefile("${path.module}/backend.tmpl",
    {
      bucket_name = aws_s3_bucket.terraform.bucket
      key         = "infra"
      region      = var.region
  })
  filename        = "${path.root}/../infra/backend.tf"
  file_permission = "0644"
}

resource "local_file" "env_backend" {
  content = templatefile("${path.module}/backend.tmpl",
    {
      bucket_name = aws_s3_bucket.terraform.bucket
      key         = "env"
      region      = var.region
  })
  filename        = "${path.root}/../env/backend.tf"
  file_permission = "0644"
}

resource "local_file" "infra_default" {
  content = templatefile("${path.module}/default_vars.tmpl",
    {
      project = local.project_name
  })
  filename        = "${path.root}/../infra/default.tfvars"
  file_permission = "0644"
}

resource "local_file" "infra_versions" {
  content         = templatefile("${path.module}/versions.tmpl", {})
  filename        = "${path.root}/../infra/versions.tf"
  file_permission = "0644"
}

resource "local_file" "env_dev" {
  content = templatefile("${path.module}/environment_vars.tmpl",
    {
      project     = local.project_name
      environment = "dev"
  })
  filename        = "${path.root}/../env/dev.tfvars"
  file_permission = "0644"
}

resource "local_file" "env_prod" {
  content = templatefile("${path.module}/environment_vars.tmpl",
    {
      project     = local.project_name
      environment = "prod"
  })
  filename        = "${path.root}/../env/prod.tfvars"
  file_permission = "0644"
}

resource "local_file" "env_variables" {
  content         = templatefile("${path.module}/variables.tmpl", {})
  filename        = "${path.root}/../env/variables.tf"
  file_permission = "0644"
}

resource "local_file" "env_versions" {
  content         = templatefile("${path.module}/versions.tmpl", {})
  filename        = "${path.root}/../env/versions.tf"
  file_permission = "0644"
}
