# INSTANCE CREATION
resource "aws_instance" "service_ec2" {
  count = length(var.services)

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = var.subnet_id

  tags = {
    Name      = "${var.project_name}-ec2-${var.services[count.index]}"
    ManagedBy = "Terraform"
  }
  # user_data = filebase64("${path.module}/full-script.sh")
}