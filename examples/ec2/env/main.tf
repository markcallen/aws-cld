module "vpc" {
  source = "../../../env/vpc/"

  project        = var.project
  environment    = var.environment
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west
  cidr           = var.cidr
  subnet_count   = var.subnet_count
}

module "vpc_peering" {
  source = "../../../env/vpc-peering/"

  project        = var.project
  environment    = var.environment
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west
  vpc_id_us_east = module.vpc.us_east_vpc.vpc_id
  vpc_id_us_west = module.vpc.us_west_vpc.vpc_id
}

module "route53" {
  source = "../../../env/route53/"

  project          = var.project
  environment      = var.environment
  environment_name = var.environment_dns_name
  domain           = var.domain
}

module "route53ns" {
  source = "../../../env/route53-ns/"

  project          = var.project
  environment      = var.environment
  environment_name = var.environment_dns_name
  domain           = var.domain
  name_servers     = module.route53.environment.name_servers

  depends_on = [
    module.route53.environment
  ]
}

module "ec2" {
  source = "../../../env/ec2/"

  project        = var.project
  environment    = var.environment
  region_us_east = var.region_us_east
  region_us_west = var.region_us_west

  route53_zone_id_us_east = module.route53.us_east.zone_id
  route53_zone_id_us_west = module.route53.us_west.zone_id

  ssh_keys = var.ssh_keys

  instance_count_us_east = 1
  instance_count_us_west = 0

  extra_disk_size  = 100
  extra_disk_count = 1
}

