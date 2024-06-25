data "aws_ecr_authorization_token" "token" {
}

locals {
  name = "demo-lambda-docker-image"
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
  create_package = false
  package_type   = "Image"
  image_uri      = module.docker_image.image_uri


  environment_variables = {
    "environment" = "poc",
  }

}

module "docker_image" {
  source  = "terraform-aws-modules/lambda/aws//modules/docker-build"
  version = "7.7.0"

  create_ecr_repo = true
  ecr_repo        = local.name

  use_image_tag    = true
  image_tag        = "1.0"
  docker_file_path = "./Dockerfile"
  source_path      = abspath(path.module)
}
