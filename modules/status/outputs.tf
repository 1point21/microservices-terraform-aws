output "ec2_status" {
  description = "details of ec2 for lighting server"
  value = { id : aws_instance.ec2_status.id
    public_ip : aws_instance.ec2_status.public_ip
  public_dns : aws_instance.ec2_status.public_dns }
}