resource "aws_dynamodb_table" "my_dynamodb_table" {
  name         = "dishes" # This will be replaced by a variable
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "dish_id" # This will be replaced by a variable

  attribute {
    name = "dish_id" # This will be replaced by a variable
    type = "S"
  }

  tags = {
    Name      = "dishes"
    Terraform = true
  }

}

locals {
  json_data = file("${path.module}/dishes.json")
  dishes    = jsondecode(local.json_data)
}

resource "aws_dynamodb_table_item" "dishes" {
  for_each   = local.dishes
  table_name = aws_dynamodb_table.my_dynamodb_table.name
  hash_key   = aws_dynamodb_table.my_dynamodb_table.hash_key
  item       = jsonencode(each.value)
}
