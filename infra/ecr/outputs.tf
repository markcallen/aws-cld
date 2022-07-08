output "repo_app_url" {
  value = aws_ecr_repository.repository[*].repository_url
}
