module "vpc" {
  source = "../../../env/vpc"

  project        = var.project
  environment    = var.environment
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west
  cidr           = var.cidr
  subnet_count   = var.subnet_count
}

module "vpc_peering" {
  source = "../../../env/vpc-peering"

  project        = var.project
  environment    = var.environment
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west
  vpc_id_us_east = module.vpc.us_east_vpc.vpc_id
  vpc_id_us_west = module.vpc.us_west_vpc.vpc_id
}

module "route53" {
  source = "../../../env/route53"

  project          = var.project
  environment      = var.environment
  environment_name = var.environment_dns_name
  domain           = var.domain
}

module "cloudflarens" {
  source = "../../../env/cloudflare-ns"

  project      = var.project
  environment  = var.environment_dns_name
  name_servers = module.route53.environment.name_servers
  zone_id      = var.zone_id

  depends_on = [
    module.route53.environment
  ]
}

module "acm" {
  source = "../../../env/acm"

  project          = var.project
  environment      = var.environment
  environment_name = var.environment_dns_name
  domain           = var.domain
  region_us_east   = var.region_us_east
  region_us_west   = var.region_us_west

  subject_alternative_names = var.alternative_names
}

module "eks" {
  source = "../../../env/eks"

  project           = var.project
  environment       = var.environment
  app_desired_count = var.app_desired_count
  app_min_count     = var.app_min_count
  app_max_count     = var.app_max_count

  region_us_east = var.region_us_east
  region_us_west = var.region_us_west
  enable_us_east = var.enable_us_east
  enable_us_west = var.enable_us_west
}

module "mysql" {
  source = "../../../env/rds"

  project     = var.project
  environment = var.environment

  region_db     = var.region_us_east
  region_backup = var.region_us_west

  database_name         = var.database_name
  username              = var.database_username
  vpc_id                = module.vpc.us_east_vpc.vpc_id
  cidr_blocks           = module.vpc.us_east_vpc.vpc_cidr_block
  subnet_group          = module.vpc.us_east_vpc.database_subnet_group
  instance_class        = "db.t4g.large"
  allocated_storage     = 20
  max_allocated_storage = 250

  database_engine               = "mysql"
  database_engine_version       = "8.0"
  database_major_engine_version = "8.0"
  database_family               = "mysql8.0"
  database_port                 = 3306
}

module "ec2-bastion" {
  source = "../../../env/ec2"

  project        = var.project
  environment    = var.environment
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west

  name                    = "b"
  root_disk_size          = 50
  route53_zone_id_us_east = module.route53.us_east.zone_id
  route53_zone_id_us_west = module.route53.us_west.zone_id
  ssh_keys                = var.ssh_keys
  instance_type           = "t3.micro"
  instance_count_us_east  = var.instance_count_us_east
  instance_count_us_west  = var.instance_count_us_west
  extra_disk_size         = 500
  extra_disk_count        = 0
}
## This doesn't work for ansible
resource "local_file" "inventory" {
  content         = format("%s\n%s", module.ec2-bastion.inventory_us_east, module.ec2-bastion.inventory_us_west)
  file_permission = "0644"
  filename        = "${path.module}/ansible/${var.environment}"
}
