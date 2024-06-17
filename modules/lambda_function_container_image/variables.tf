variable "lambda_runtime" {
  description = "The runtime of the Lambda function"
  type        = string
  default     = "python3.11"

}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
}
