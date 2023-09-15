module "asm_us_east" {
  source = "../modules/asm"

  providers = {
    aws = aws.us_east
  }

  environment = var.environment
  secrets     = var.secrets
}

module "asm_us_west" {
  source = "../modules/asm"

  providers = {
    aws = aws.us_west
  }

  environment = var.environment
  secrets     = var.secrets
}
