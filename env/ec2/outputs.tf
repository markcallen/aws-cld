output "inventory_us_east" {
  value = module.ec2_us_east.inventory
}
output "dns_names_us_east" {
  value = module.ec2_us_east.dns_names
}
