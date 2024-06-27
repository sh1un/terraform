terraform {
  backend "s3" {
    bucket         = "terraform-state-20240618152116874600000001"
    region         = "ap-northeast-1"
    key            = "shiun-api-gateway-cognito-lambda-dynamodb-poc/terraform-poc.tfstate"
    dynamodb_table = "terraform-locks"
  }
  required_version = ">= 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.54.0"
    }
  }
}
