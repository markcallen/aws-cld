locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "aws-cld"
    Project     = var.project
  }
}

module "asm_us_east" {
  source = "../modules/asm"

  providers = {
    aws = aws.us_east
  }

  environment = var.environment
  secrets     = var.secrets

  tags = local.common_tags
}

module "asm_us_west" {
  source = "../modules/asm"

  providers = {
    aws = aws.us_west
  }

  environment = var.environment
  secrets     = var.secrets

  tags = local.common_tags
}
