output "table_names" {
  description = "list of the names of the tables created"
  value = aws_dynamodb_table.table[*].name
}