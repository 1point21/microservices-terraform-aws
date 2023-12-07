output "security_group_ids" {
  description = "a list of strings of security group ids"
  value = [
    aws_security_group.sg_allow_http.id,
    aws_security_group.sg_allow_https.id,
    aws_security_group.sg_allow_ssh.id,
    aws_security_group.sg_allow_egress.id
  ]
}

output "lb_security_group_ids" {
  description = "a list of strings of the security groups to be applied to the load balancer"
  value       = [aws_security_group.sg_allow_http.id, aws_security_group.sg_allow_https.id, aws_security_group.sg_allow_egress.id]
}

