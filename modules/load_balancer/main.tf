resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets_ids
  enable_deletion_protection = false

    tags = {
        Name        = "${var.project_name}-alb"

    }
}

resource "aws_lb_target_group" "web_alb_tg" {
  name     = "${var.project_name}-web-alb-tg"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
  tags = {
    Name = "${var.project_name}-web-alb-tg"
  }
}


// Attach the target group to the Auto Scaling Group
resource "aws_autoscaling_attachment" "asg_attach" {
    autoscaling_group_name = var.asg_name
    lb_target_group_arn   = aws_lb_target_group.web_alb_tg.arn
}

// Create a listener for the ALB to forward HTTP traffic to the target group
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"
  
  # Default action to forward traffic to the target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_alb_tg.arn
  }
}