locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "aws-cld"
    Project     = var.project
  }
}
