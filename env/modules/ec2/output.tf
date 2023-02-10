output "dns_names" {
  value = aws_route53_record.ec2[*].name
}
output "ips" {
  value = aws_instance.ec2[*].public_ip
}

output "inventory" {
  value = templatefile(
    "${path.module}/inventory.tmpl",
    {
      user  = "ubuntu"
      name  = var.project
      nodes = aws_instance.ec2[*].public_ip
    }
  )
}
