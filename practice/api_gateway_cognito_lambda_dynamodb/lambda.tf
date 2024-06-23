
data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "${path.module}/lambda_code.py"
  output_path = "${path.module}/lambda_code.zip"

}

resource "aws_lambda_function" "my-lambda-function" {
  filename      = "${path.module}/lambda_code.zip"
  function_name = "api-gateway-lambda"
  role          = aws_iam_role.terraform_function_role.arn
  handler       = "lambda_code.lambda_handler"
  runtime       = "python3.11"

  source_code_hash = data.archive_file.lambda_code.output_base64sha256
}

# Allowing API Gateway to Access Lambda
resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = aws_lambda_function.my-lambda-function.function_name
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.my_rest_api.execution_arn}/*/*"
}
