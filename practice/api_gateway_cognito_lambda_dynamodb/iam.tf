
# Assume role policy for API Gateway
data "aws_iam_policy_document" "AWSLambdaTrusyPolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# IAM role for Lambda function
resource "aws_iam_role" "terraform_function_role" {

  name               = "terraform_function_role"
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrusyPolicy.json

}

# Attach AWS managed policy to the role
resource "aws_iam_role_policy_attachment" "terraform_lambda_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.terraform_function_role.name

}

# Attach a cutom policy to the role
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name   = "lambda_dynamodb_policy"
  role   = aws_iam_role.terraform_function_role.name
  policy = file("${path.module}/lambda_dynamodb_policy.json")
}
