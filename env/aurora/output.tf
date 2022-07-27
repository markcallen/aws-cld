output "rest_endpoint" {
  value = module.psql_rest.endpoint
}
output "rest_username" {
  value = module.psql_rest.username
}
output "rest_password" {
  value = module.psql_rest.password
}
output "web_endpoint" {
  value = module.web-app.endpoint
}
output "web_username" {
  value = module.web-app.username
}
output "web_password" {
  value = module.web-app.password
}
output "ltf_endpoint" {
  value = module.ltf_model.endpoint
}
output "ltf_username" {
  value = module.ltf_model.username
}
output "ltf_password" {
  value = module.ltf_model.password
}
