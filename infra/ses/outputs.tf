output "username" {
  value = aws_iam_user.ses_user.name
}

output "user_access_key" {
  value     = aws_iam_access_key.ses_access_key
  sensitive = true
}
