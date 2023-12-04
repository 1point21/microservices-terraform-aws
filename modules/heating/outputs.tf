output "ec2" {
  description = "details of ec2 for heating server"
  value = { id : aws_instance.ec2_heating.id
    public_ip : aws_instance.ec2_heating.public_ip
  public_dns : aws_instance.ec2_heating.public_dns }
}

output "lighting_table" {
  description = "name of the DynamoDB table for lighting"
  value       = aws_dynamodb_table.heating_table.name
}