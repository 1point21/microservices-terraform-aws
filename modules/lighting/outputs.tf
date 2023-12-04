output "ec2" {
    description = "details of ec2 for lighting server"
    value = {id: aws_instance.ec2_lighting.id
    public_ip: aws_instance.ec2_lighting.public_ip
    public_dns: aws_instance.ec2_lighting.public_dns}
}

output "lighting_table" {
    description = "name of the DynamoDB table for lighting"
    value = aws_dynamodb_table.lighting_table.name
}