### CREATE AMI IMAGES ###
resource "aws_ami_from_instance" "service_ami" {
  count              = length(var.services)
  name               = "${var.project_name}-${var.services[count.index]}_ami"
  source_instance_id = var.ec2_ids[count.index]

  tags = {
    Name      = "${var.project_name}-ami-${var.services[count.index]}"
    ManagedBy = "Terraform"
  }
}

### LAUNCH TEMPLATES ###
resource "aws_launch_template" "service_launch_template" {
  count = length(var.services)

  image_id      = aws_ami_from_instance.service_ami[count.index].id
  instance_type = "t2.micro"
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_group_ids
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name      = "${var.project_name}-launchtemplate-${var.services[count.index]}"
      ManagedBy = "Terraform"
    }
  }
}

### AUTOSCALE GROUPS ###
resource "aws_autoscaling_group" "asg" {
  count = length(var.services)

  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_size
  vpc_zone_identifier = var.autoscale_public_subnets

  launch_template {
    id      = aws_launch_template.service_launch_template[count.index].id
    version = "$Latest"
  }
}

### AUTOSCALE-TARGETGROUP ATTACHMENT ###
resource "aws_autoscaling_attachment" "service_attach" {
  count                  = length(var.services)
  autoscaling_group_name = aws_autoscaling_group.asg[count.index].name
  lb_target_group_arn    = var.tg_arns[count.index]
}
