resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
 
  tags = {
    Name ="EC2 Role"
  }
}

// Attach the AmazonSSMManagedInstanceCore policy to the EC2 role
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name = "${var.project_name}-ec2-instance-profile"
  }
}
resource "aws_launch_template" "web" {
    name_prefix   = "${var.project_name}-web-"
    image_id      = var.ami_id
    instance_type = var.instance_type
    key_name      = var.key_name
    vpc_security_group_ids = [var.ec2_sg_id]
    user_data = base64encode(var.user_data_script)
    iam_instance_profile {
        name = aws_iam_instance_profile.ec2_instance_profile.name
    }

    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "${var.project_name}-web-instance"
        }
    }
    
    lifecycle {
        create_before_destroy = true
    }
    
}

resource "aws_autoscaling_group" "asg_web" {
    name                = "${var.project_name}-asg-web"
    vpc_zone_identifier = var.private_subnet_ids
    min_size            = var.asg_min_size
    max_size            = var.asg_max_size
    desired_capacity    = var.asg_desired_capacity
    health_check_type = "ELB"
    health_check_grace_period = 300

     launch_template {
        id      = aws_launch_template.web.id
        version = "$Latest"
    }
    
    tag {
        key                 = "Name"
        value               = "${var.project_name}-asg-web"
        propagate_at_launch = true
    }
    tag {
        key                 = "Project"
        value               = var.project_name
        propagate_at_launch = true
    }
    lifecycle {
        create_before_destroy = true
    }
  
}