resource "aws_elasticache_replication_group" "us_east" {
  provider = aws.us_east

  replication_group_id = "redis-cluster-us-east-${var.environment}"
  description          = "redis cluster us-east ${var.environment}"

  node_type = var.node_type
  port      = 6379

  snapshot_retention_limit = 5
  snapshot_window          = "00:00-05:00"

  subnet_group_name          = var.subnet_group_us_east_name
  security_group_ids         = [aws_security_group.elasticache_east.id]
  automatic_failover_enabled = true

  replicas_per_node_group = 1
  num_node_groups         = 3

  tags = {
    Name        = "redis-cluster-us-east-${var.environment}"
    Environment = var.environment
    Project     = var.project
  }
}
