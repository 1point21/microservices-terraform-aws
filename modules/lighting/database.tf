# TABLE CREATION
resource "aws_dynamodb_table" "lighting_table" {
  name = "${var.project_name}-lighting-table"

  tags = {
    Name      = "${var.project_name}-lighting-table"
    ManagedBy = "Terraform"
  }
}
