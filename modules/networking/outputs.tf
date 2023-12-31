output "vpc_id" {
  description = "id of the main vpc"
  value       = aws_vpc.main.id
}

output "pub_sub_ids" {
  description = "list of ids of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "asg_pub_subs" {
  description = "list of ids of public subnets for use in auto-scaling"
  value       = [aws_subnet.public_subnet[1].id, aws_subnet.public_subnet[2].id]
}


### TERRATEST ###
output "main_vpc_id" {
  value       = aws_vpc.main.id
  description = "The main VPC id"
}

output "public_subnet_id" {
  value       = aws_subnet.public_subnet[0].id
  description = "The public subnet id"
}

output "private_subnet_id" {
  value       = aws_subnet.private_subnet[0].id
  description = "The private subnet id"
}