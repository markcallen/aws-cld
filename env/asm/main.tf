provider "aws" {
  region = "us-east-2"
}

resource "aws_secretsmanager_secret" "nval-web-app" {
  name = "${var.environment}.nval-web-app"
}

resource "aws_secretsmanager_secret" "nval-rest-api" {
  name = "${var.environment}.nval-rest-api"
}

resource "aws_secretsmanager_secret" "ltf-model" {
  name = "${var.environment}.ltf-model"
}
