output "secrets" {
  value = aws_secretsmanager_secret.secrets[*].name
}
