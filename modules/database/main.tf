# TABLE CREATION

resource "aws_dynamodb_table" "table" {
  count          = length(var.services) - 1
  name           = var.services[count.index + 1]
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }

  tags = {
    Name      = "${var.services[count.index + 1]}"
    ManagedBy = "Terraform"
  }
}