provider "aws" {
  alias  = "us_east"
  region = var.region_us_east
}

provider "aws" {
  alias  = "us_west"
  region = var.region_us_west
}
