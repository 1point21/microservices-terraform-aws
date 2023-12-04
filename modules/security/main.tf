data "http" "myipaddr" {
  url = "http://icanhazip.com"
}

### HTTP ###

# HTTP SECURITY GROUP
resource "aws_security_group" "sg_allow_http" {
  name        = "allow_http"
  description = "allow selected http traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name      = "${var.project_name}-sg-http"
    ManagedBy = "Terraform"
  }
}

# HTTP RULES
resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg_allow_http.id
}

resource "aws_security_group_rule" "http_on_3000" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg_allow_http.id
}

### HTTPS ###

# HTTPS SECURITY GROUP
resource "aws_security_group" "sg_allow_https" {
  name        = "allow_https"
  description = "allow selected https traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name      = "${var.project_name}-sg-https"
    ManagedBy = "Terraform"
  }
}

# HTTPS RULES
resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg_allow_https.id
}

### SSH ###

# SSH SECURITY GROUP
resource "aws_security_group" "sg_allow_ssh" {
  name        = "allow_ssh"
  description = "allow ssh from my users ip"
  vpc_id      = var.vpc_id

  tags = {
    Name      = "${var.project_name}-sg-ssh"
    ManagedBy = "Terraform"
  }
}

# SSH RULES
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myipaddr.response_body)}/32"]
  security_group_id = aws_security_group.sg_allow_ssh.id
}

### EGRESS ###

# EGRESS SECURITY GROUPS
resource "aws_security_group" "sg_allow_egress" {
  name        = "allow_egress"
  description = "allow selected egress traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name      = "${var.project_name}-sg-egress"
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
