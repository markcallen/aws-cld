output "users" {
  value = { for p in aws_iam_user.user : p.name => p.arn }
}
output "passwords" {
  value = { for p in aws_iam_user_login_profile.login_profile : p.user => p.encrypted_password }
}
output "access_key_ids" {
  value = { for p in aws_iam_access_key.user : p.user => p.id }
}
output "secret_access_keys" {
  value = { for p in aws_iam_access_key.user : p.user => p.encrypted_secret }
}
