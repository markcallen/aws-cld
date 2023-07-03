module "psql" {
  source = "../modules/aurora"

  providers = {
    aws.us_east = aws.us_east
    aws.us_west = aws.us_west
  }

  environment                = var.environment
  database_engine            = "aurora-postgresql"
  database_engine_version    = "13.4"
  database_name              = var.database_name
  rds_master_username        = var.master_username
  rds_master_password        = var.master_password
  subnet_count_us_east       = var.subnet_count_us_east
  subnet_count_us_west       = var.subnet_count_us_west
  instance_class             = var.instance_class
  db_subnet_us_east          = data.aws_vpc.us_east.tags.Name
  db_subnet_us_west          = data.aws_vpc.us_west.tags.Name
  vpc_security_group_us_east = [module.security_group_database_us_east.id]
  vpc_security_group_us_west = [module.security_group_database_us_west.id]
}
