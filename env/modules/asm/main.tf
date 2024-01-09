resource "aws_secretsmanager_secret" "secrets" {
  count = length(var.secrets)
  name  = "${var.environment}/${element(var.secrets, count.index)}"

  tags = var.tags
}
