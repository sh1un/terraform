# Create an API Gateway REST API
resource "aws_api_gateway_rest_api" "my_rest_api" {
  name        = "my_rest_api"
  description = "This is my API for practice"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Resource for the path /dishes
resource "aws_api_gateway_resource" "rest_api_resource_dishes" {
  rest_api_id = aws_api_gateway_rest_api.my_rest_api.id
  parent_id   = aws_api_gateway_rest_api.my_rest_api.root_resource_id
  path_part   = "dishes"
}

# API Resource for the path /dish
resource "aws_api_gateway_resource" "rest_api_resource_dish" {
  rest_api_id = aws_api_gateway_rest_api.my_rest_api.id
  parent_id   = aws_api_gateway_resource.rest_api_resource_dishes.id
  path_part   = "dish"

}
