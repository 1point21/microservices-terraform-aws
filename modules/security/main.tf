data "http" "myipaddr" {
  url = "http://icanhazip.com"
}

### INGRESS ###

# INGRESS SECURITY GROUP
resource "aws_security_group" "sg_allow_ingress" {
  name        = "allow_ingress"
  description = "allow selected ingress traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-sg-igress"
    ManagedBy = "Terraform"
  }
}

# INGRESS RULES
resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg_allow_ingress.id
}

# COMMENTED OUT ATM SO THAT I DON'T NEED TO DEAL WITH CERTIFICATES

# resource "aws_security_group_rule" "https" {
#   type = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   ipv6_cidr_blocks  = ["::/0"]
#   security_group_id = aws_security_group.sg_allow_ingress.id
# }

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myipaddr.response_body)}/32"]
  security_group_id = aws_security_group.sg_allow_egress.id
}

### EGRESS

# EGRESS SECURITY GROUPS
resource "aws_security_group" "sg_allow_egress" {
  name        = "allow_egress"
  description = "allow selected egress traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-sg-egress"
    ManagedBy = "Terraform"
  }
}

# EGRESS RULES
resource "aws_security_group_rule" "all_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg_allow_egress.id
}
