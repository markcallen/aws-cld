provider "aws" {
  alias  = "db"
  region = var.region_db
}

data "aws_caller_identity" "current" {}

locals {
  name             = "${var.database_name}-${var.environment}"
  current_identity = data.aws_caller_identity.current.arn
  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  providers = {
    aws = aws.db
  }

  name        = local.name
  description = "Complete PostgreSQL example security group"
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = var.cidr_blocks
    },
  ]

  tags = local.tags
}

################################################################################
# RDS Module
################################################################################

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0.1"

  providers = {
    aws = aws.db
  }

  identifier                     = local.name
  instance_use_identifier_prefix = true

  create_db_option_group    = false
  create_db_parameter_group = false

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "14.3"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = var.instance_class

  allocated_storage = var.allocated_storage

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = var.database_name
  username = var.username
  port     = 5432

  db_subnet_group_name   = var.subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = local.tags
}

################################################################################
# RDS Automated Backups Replication Module
################################################################################
provider "aws" {
  alias  = "backup"
  region = var.region_backup
}

module "kms" {
  source      = "terraform-aws-modules/kms/aws"
  version     = "~> 1.0"
  description = "KMS key for cross region automated backups replication"

  # Aliases
  aliases                 = [local.name]
  aliases_use_name_prefix = true

  key_owners = [local.current_identity]

  tags = local.tags

  providers = {
    aws = aws.backup
  }
}

resource "aws_db_instance_automated_backups_replication" "backup" {
  provider = aws.backup

  source_db_instance_arn = module.db.db_instance_arn
  kms_key_id             = module.kms.key_arn
  retention_period       = 7

  depends_on = [
    module.db
  ]

}
