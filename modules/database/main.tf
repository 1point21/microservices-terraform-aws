# TABLE CREATION

resource "aws_dynamodb_table" "lighting_table" {
  count = length(var.services) - 1
  name           = "${var.services[count.index]}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }

  tags = {
    Name      = "${var.services[count.index]}"
    ManagedBy = "Terraform"
  }
}