module "psql_rest" {
  source = "../modules/aurora"

  providers = {
    aws.us_east = aws.us_east
    aws.us_west = aws.us_west
  }

  environment                = var.environment
  database_engine            = "aurora-postgresql"
  database_engine_version    = "13.4"
  database_name              = "rest"
  rds_master_username        = var.rest_master_username
  rds_master_password        = var.rest_master_password
  subnet_count_us_east       = var.rest_subnet_count_us_east
  subnet_count_us_west       = var.rest_subnet_count_us_west
  instance_class             = var.rest_instance_class
  db_subnet_us_east          = data.aws_vpc.us_east.tags.Name
  db_subnet_us_west          = data.aws_vpc.us_west.tags.Name
  vpc_security_group_us_east = [module.security_group_database_us_east.id]
  vpc_security_group_us_west = [module.security_group_database_us_west.id]
}

module "web-app" {
  source = "../modules/aurora"

  providers = {
    aws.us_east = aws.us_east
    aws.us_west = aws.us_west
  }

  environment                = var.environment
  database_engine            = "aurora-postgresql"
  database_engine_version    = "13.4"
  database_name              = "web-app"
  rds_master_username        = var.web_master_username
  rds_master_password        = var.web_master_password
  subnet_count_us_east       = var.web_subnet_count_us_east
  subnet_count_us_west       = var.web_subnet_count_us_west
  instance_class             = var.web_instance_class
  db_subnet_us_east          = data.aws_vpc.us_east.tags.Name
  db_subnet_us_west          = data.aws_vpc.us_west.tags.Name
  vpc_security_group_us_east = [module.security_group_database_us_east.id]
  vpc_security_group_us_west = [module.security_group_database_us_west.id]
}

module "ltf_model" {
  source = "../modules/aurora"

  providers = {
    aws.us_east = aws.us_east
    aws.us_west = aws.us_west
  }

  environment                = var.environment
  database_engine            = "aurora-postgresql"
  database_engine_version    = "13.4"
  database_name              = "ltf"
  rds_master_username        = var.ltf_master_username
  rds_master_password        = var.ltf_master_password
  subnet_count_us_east       = var.ltf_subnet_count_us_east
  subnet_count_us_west       = var.ltf_subnet_count_us_west
  instance_class             = var.ltf_instance_class
  db_subnet_us_east          = data.aws_vpc.us_east.tags.Name
  db_subnet_us_west          = data.aws_vpc.us_west.tags.Name
  vpc_security_group_us_east = [module.security_group_database_us_east.id]
  vpc_security_group_us_west = [module.security_group_database_us_west.id]
}

