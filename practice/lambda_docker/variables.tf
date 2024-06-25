variable "aws_region" {
  description = "aws region"
  default     = "us-west-2" # local-dev
}

variable "environment" {
  description = "Current environtment: prod(ap-northeast-1)/dev(us-east-1)/local-dev(us-west-2), default dev(us-east-1)"
  default     = "dev"
}
