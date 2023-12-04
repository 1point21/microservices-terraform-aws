output "vpc_id" {
    description = "id of the main vpc"
    value = aws_vpc.main.id
}   