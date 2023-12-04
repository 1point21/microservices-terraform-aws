output "vpc_id" {
  description = "id of the main vpc"
  value       = aws_vpc.main.id
}

output "pub_sub_ids" {
  description = "list of ids of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}