resource "aws_rds_global_cluster" "aurora_cluster" {
  provider                  = aws.us_east
  global_cluster_identifier = "${var.database_name}-${var.environment}"
  engine                    = var.database_engine
  engine_version            = var.database_engine_version
  database_name             = var.database_name
}

resource "aws_rds_cluster" "aurora_cluster_us_east" {
  provider                  = aws.us_east
  cluster_identifier        = "${var.database_name}-${var.environment}-us-east"
  global_cluster_identifier = aws_rds_global_cluster.aurora_cluster.id

  master_username              = var.rds_master_username
  master_password              = var.rds_master_password
  engine                       = aws_rds_global_cluster.aurora_cluster.engine
  engine_version               = aws_rds_global_cluster.aurora_cluster.engine_version
  backup_retention_period      = 14
  preferred_backup_window      = "02:00-03:00"
  preferred_maintenance_window = "wed:03:00-wed:04:00"
  db_subnet_group_name         = var.db_subnet_us_east
  skip_final_snapshot          = true
  vpc_security_group_ids       = var.vpc_security_group_us_east

  tags = {
    Name        = "${var.database_name}-${var.environment}-us-east"
    VPC         = var.db_subnet_us_east
    ManagedBy   = "terraform"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [replication_source_identifier]
  }

  depends_on = [
    aws_rds_global_cluster.aurora_cluster
  ]
}

resource "aws_rds_cluster" "aurora_cluster_us_west" {
  provider                  = aws.us_west
  cluster_identifier        = "${var.database_name}-${var.environment}-us-west"
  global_cluster_identifier = aws_rds_global_cluster.aurora_cluster.id

  engine                       = aws_rds_global_cluster.aurora_cluster.engine
  engine_version               = aws_rds_global_cluster.aurora_cluster.engine_version
  backup_retention_period      = 14
  preferred_backup_window      = "02:00-03:00"
  preferred_maintenance_window = "wed:03:00-wed:04:00"
  db_subnet_group_name         = var.db_subnet_us_west
  skip_final_snapshot          = true
  vpc_security_group_ids       = var.vpc_security_group_us_west

  tags = {
    Name        = "${var.database_name}-${var.environment}-us-west"
    VPC         = var.db_subnet_us_west
    ManagedBy   = "terraform"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [replication_source_identifier]
  }

  depends_on = [
    aws_rds_cluster.aurora_cluster_us_east
  ]
}

resource "aws_rds_cluster_instance" "aurora_cluster_instance_us_east" {
  provider = aws.us_east
  count    = var.subnet_count_us_east

  identifier           = "${var.database_name}-${var.environment}-instance-us-east-${count.index}"
  cluster_identifier   = aws_rds_cluster.aurora_cluster_us_east.id
  engine               = aws_rds_global_cluster.aurora_cluster.engine
  engine_version       = aws_rds_global_cluster.aurora_cluster.engine_version
  instance_class       = var.instance_class
  db_subnet_group_name = var.db_subnet_us_east
  publicly_accessible  = true

  tags = {
    Name        = "${var.database_name}-${var.environment}-instance-us-east-${count.index}"
    VPC         = var.db_subnet_us_east
    ManagedBy   = "terraform"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_rds_cluster.aurora_cluster_us_east
  ]
}

resource "aws_rds_cluster_instance" "aurora_cluster_instance_us_west" {
  provider = aws.us_west
  count    = var.subnet_count_us_west

  identifier           = "${var.database_name}-${var.environment}-instance-us-west-${count.index}"
  engine               = aws_rds_global_cluster.aurora_cluster.engine
  engine_version       = aws_rds_global_cluster.aurora_cluster.engine_version
  cluster_identifier   = aws_rds_cluster.aurora_cluster_us_west.id
  instance_class       = var.instance_class
  db_subnet_group_name = var.db_subnet_us_west
  publicly_accessible  = true

  tags = {
    Name        = "${var.database_name}-${var.environment}-instance-us-west-${count.index}"
    VPC         = var.db_subnet_us_west
    ManagedBy   = "terraform"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_rds_cluster.aurora_cluster_us_west
  ]
}
