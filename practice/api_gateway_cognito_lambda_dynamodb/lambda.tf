
data "archive_file" "lambda_code" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code.py"
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
