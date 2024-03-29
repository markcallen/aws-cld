output "dns_names" {
  value = aws_route53_record.ec2[*].name
}
output "ips" {
  value = module.ec2_instance[*].instance.public_ip
}

output "inventory" {
  value = templatefile(
    "${path.module}/inventory.tmpl",
    {
      user   = "ubuntu"
      name   = var.name
      nodes  = aws_route53_record.ec2[*].name
      region = var.region
    }
  )
}
