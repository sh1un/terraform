data "aws_ecr_authorization_token" "token" {
}

locals {
  name        = "demo-lambda-docker-image"
  source_path = abspath(path.module)
}

provider "docker" {
  registry_auth {
    address  = "070576557102.dkr.ecr.${var.aws_region}.amazonaws.com" # rich-liu
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}




module "aws_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.7.0"

  function_name  = "from_terraform_module_function"
  description    = "This is a demo, for lambda container image"
  create_package = false
  package_type   = "Image"
  image_uri      = module.docker_image.image_uri
  timeout        = 60

  publish = true


  environment_variables = {
    "environment" = "poc",
  }

  tags = {
    "Terraform" = "true"
  }
}

module "docker_image" {
  source  = "terraform-aws-modules/lambda/aws//modules/docker-build"
  version = "7.7.0"

  create_ecr_repo = true
  keep_remotely   = true
  use_image_tag   = true
  ecr_repo        = local.name

  image_tag        = "latest"
  docker_file_path = "./Dockerfile"
  source_path      = local.source_path

}
