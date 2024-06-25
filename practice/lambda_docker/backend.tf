terraform {
  backend "s3" {
    bucket = "terraform-state-20240618152116874600000001"
    region = "us-west-2"
    key    = "lambda_docker/poc/terraform.tfstate"
  }
  required_version = ">= 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.54.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}
