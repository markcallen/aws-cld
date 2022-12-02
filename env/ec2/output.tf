output "dns_name_us_east" {
  value = aws_route53_record.ec2_us_east[*].name
}
output "dns_name_us_west" {
  value = aws_route53_record.ec2_us_west[*].name
}

output "ip_us_east" {
  value = aws_instance.us_east[*].public_ip
}
output "ip_us_west" {
  value = aws_instance.us_west[*].public_ip
}

output "inventory" {
  value = templatefile(
    "${path.module}/inventory.tmpl",
    {
      user  = "ubuntu"
      name  = var.name
      nodes = concat(aws_instance.us_east[*].public_ip, aws_instance.us_west[*].public_ip)
    }
  )
}
