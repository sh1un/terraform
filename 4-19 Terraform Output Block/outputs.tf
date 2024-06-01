output "hello_world" {
  value       = "Hello, World!"
  description = "Print a hello world message."

}

output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of the VPC."

}

output "public_url" {
  description = "public url of the load balancer"
  value       = "https://${aws_instance.web_server.public_ip}:8080/index.html"
}

output "vpc_info" {
  description = "Information about the VPC."
  value       = "Your ${aws_vpc.vpc.tags.Environment} VPC ID is ${aws_vpc.vpc.id} and the CIDR block is ${aws_vpc.vpc.cidr_block}"
}
