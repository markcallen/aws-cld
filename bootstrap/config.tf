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

resource "local_file" "env_dev" {
  content = templatefile("${path.module}/environment_vars.tmpl",
    {
      project     = local.project_name
      environment = "dev"
  })
  filename        = "${path.root}/../env/dev.tfvars"
  file_permission = "0644"
}

resource "local_file" "env_stage" {
  content = templatefile("${path.module}/environment_vars.tmpl",
    {
      project     = local.project_name
      environment = "stage"
  })
  filename        = "${path.root}/../env/stage.tfvars"
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
