output "security_group_ids" {
  description = "a list of strings of security group ids"
  value       = [aws_security_group.sg_allow_ingress.id, aws_security_group.sg_allow_egress.id]
}
