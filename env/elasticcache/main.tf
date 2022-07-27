data "aws_vpc" "us_east" {
  provider = aws.us_east
  tags = {
    Name        = "us-east-${var.environment}"
    Environment = var.environment
  }
}

data "aws_vpc" "us_west" {
  provider = aws.us_west
  tags = {
    Name        = "us-west-${var.environment}"
    Environment = var.environment
  }
}

data "aws_subnet" "us_east" {
  provider = aws.us_east
  count    = 2
  filter {
    name   = "cidr"
    values = ["${var.cidr_start_east}.${count.index + 101}.0/24"]
  }
}

data "aws_subnet" "us_west" {
  provider = aws.us_west
  count    = 2
  filter {
    name   = "cidr"
    values = ["${var.cidr_start_west}.${count.index + 101}.0/24"]
  }
}

resource "aws_elasticache_subnet_group" "us_east" {
  provider = aws.us_east

  name       = "us-east-${var.environment}-cache-subnet"
  subnet_ids = data.aws_subnet.us_east.*.id
}

resource "aws_elasticache_replication_group" "us_east" {
  provider = aws.us_east

  replication_group_id = "redis-cluster-us-east-${var.environment}"
  description          = "redis cluster us-east ${var.environment}"

  node_type            = var.node_type
  parameter_group_name = "default.redis6.x.cluster.on"
  port                 = 6379

  snapshot_retention_limit = 5
  snapshot_window          = "00:00-05:00"

  subnet_group_name          = aws_elasticache_subnet_group.us_east.name
  security_group_ids         = [aws_security_group.elasticache_east.id]
  automatic_failover_enabled = true

  replicas_per_node_group = 1
  num_node_groups         = 3

  tags = {
    Name        = "redis-cluster-us-east-${var.environment}"
    Environment = var.environment
  }
}
