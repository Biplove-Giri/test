terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.1"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

 
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
 
resource "aws_secretsmanager_secret" "example" {
  name = "example"
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.example.id
  secret_string = <<EOF
   {
    "username": "adminaccount",
    "password": "${random_password.password.result}"
   }
EOF
}

output "arn" "secret_arn" {
  description = "AWS SecretManager Secret ARN"
  value       = aws_secretsmanager_secret.example.arn
}

