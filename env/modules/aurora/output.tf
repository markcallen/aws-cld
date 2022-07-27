output "endpoint" {
  value = aws_rds_cluster.aurora_cluster_us_east.endpoint
}
output "username" {
  value = var.rds_master_username
}
output "password" {
  value = var.rds_master_password
}
