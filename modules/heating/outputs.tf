output "ec2_heating" {
  description = "details of ec2 for heating server"
  value = { id : aws_instance.ec2_heating.id
    public_ip : aws_instance.ec2_heating.public_ip
  public_dns : aws_instance.ec2_heating.public_dns }
}

output "heating_table" {
  description = "name of the DynamoDB table for heating"
  value       = aws_dynamodb_table.heating_table.name
}