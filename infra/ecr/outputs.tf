output "repo_app_urls" {
  value = aws_ecr_repository.repository[*].repository_url
}
