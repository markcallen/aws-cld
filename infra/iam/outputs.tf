output "user" {
  value = { for p in aws_iam_user.user : p.name => p.arn }
}
output "passwords" {
  value = { for p in aws_iam_user_login_profile.login_profile : p.user => p.encrypted_password }
}
