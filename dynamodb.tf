resource "aws_dynamodb_table" "terraform" {
  name         = var.dynamodb_tflock_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

