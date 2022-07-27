#output "primary_endpoint" {
#  value = aws_elasticache_replication_group.us_east.primary_endpoint_address
#}
#output "reader_endpoint" {
#  value = aws_elasticache_replication_group.us_east.reader_endpoint_address 
#}
output "configuration_endpoint_address" {
  value = aws_elasticache_replication_group.us_east.configuration_endpoint_address
}


