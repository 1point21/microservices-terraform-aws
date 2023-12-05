# TABLE CREATION
resource "aws_dynamodb_table" "heating_table" {
  name           = "heating"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }

  tags = {
    Name      = "heating"
    ManagedBy = "Terraform"
  }
}

## NOTE - I want to later refactor to be able to use a dynamic name for the table.
# at the moment, I can't because the table name "heating" is hardcoded in the model.js code for the app, even though it is also specified as an environment variable