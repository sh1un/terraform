resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = "demo"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "demo_id"

  attribute {
    name = "demo_id"
    type = "S"
  }

  tags = {
    Service = var.service_underscore
  }
}
