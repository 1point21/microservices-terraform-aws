output "ec2" {
  description = "output selected details for each server created by module as array of objects"
  value = [for instance in aws_instance.service_ec2: 
  { name: instance.tags.Name
    id : instance.id,
    public_ip : instance.public_ip,
  public_dns : instance.public_dns }]

}