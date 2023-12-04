# TABLE CREATION
resource "aws_dynamodb_table" "lighting_table" {
  name           = "${var.project_name}-lighting-table"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }

  tags = {
    Name      = "${var.project_name}-lighting-table"
    ManagedBy = "Terraform"
  }
}
