variable "project" {
  type = string
}

module "iam" {
  source = "../../../infra/iam"

  project = var.project

  public_key_filename = "./public-key.gpg"
  iam_users           = ["marka_eng", "marka_ops"]
  eng_users           = ["marka_eng"]
  ops_users           = ["marka_ops"]
}

module "ecr" {
  source = "../../../infra/ecr"

  project = var.project

  ecr_repositories = ["marka1", "marka2"]
}

output "passwords" {
  value = module.iam.passwords
}

output "repositories" {
  value = module.ecr.repo_app_urls
}
