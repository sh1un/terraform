output "hello_world" {
  value       = "Hello, World!"
  description = "Print a hello world message."

}

output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of the VPC."

}
