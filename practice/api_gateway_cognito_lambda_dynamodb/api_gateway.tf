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


#####################################################################################################
########################### GET /dishes #########################################################
#####################################################################################################
resource "aws_api_gateway_method" "list_dishes" {
  rest_api_id   = aws_api_gateway_rest_api.my_rest_api.id
  resource_id   = aws_api_gateway_resource.rest_api_resource_dishes.id
  http_method   = "GET"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "list_dishes_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource_dishes.id
  http_method = aws_api_gateway_method.list_dishes.http_method
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.my-lambda-function.invoke_arn
}

# resource "aws_api_gateway_method_response" "list_dished_method_response_200" {
#   rest_api_id = aws_api_gateway_rest_api.my_rest_api.id
#   resource_id = aws_api_gateway_resource.rest_api_resource_dishes.id
#   http_method = aws_api_gateway_method.list_dishes.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers"     = true,
#     "method.response.header.Access-Control-Allow-Methods"     = true,
#     "method.response.header.Access-Control-Allow-Origin"      = true,
#     "method.response.header.Access-Control-Allow-Credentials" = true
#   }
# }


# Deployment
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_rest_api.id

  depends_on = [aws_api_gateway_integration.list_dishes_lambda_integration]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.rest_api_resource_dishes,
      aws_api_gateway_integration.list_dishes_lambda_integration,
      aws_api_gateway_method.list_dishes
    ]))
  }
}


resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = "dev"
  rest_api_id   = aws_api_gateway_rest_api.my_rest_api.id
}

# Logging
resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.my_rest_api.id
  stage_name  = aws_api_gateway_stage.dev.stage_name
  method_path = "*/*"
  settings {
    logging_level      = "INFO"
    metrics_enabled    = true
    data_trace_enabled = true
  }
}
