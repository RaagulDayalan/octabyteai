resource "aws_lb" "app_alb" {
  name               = "${var.infra_prefix}-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.ec2_app_lb_sg.id]
  subnets           = var.subnet_ids 
  tags = {
    Name = "${var.infra_prefix}-app-alb"
        
    
  }
}

resource "aws_lb_listener" "https_app" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.app_domain_cert

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_alb_target_group.arn
  }
}


resource "aws_lb_listener" "app_alb_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "app_alb_target_group" {
  name     = "${var.infra_prefix}-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id 

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.infra_prefix}-app-tg"
        
    
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  name = "${var.infra_prefix}-app-asg"
  desired_capacity     = 0
  max_size             = 0
  min_size             = 0
  vpc_zone_identifier  = var.subnet_ids
  launch_template {
    id      =  aws_launch_template.template_app_LT.id
    version = "$Latest"
  }
  health_check_type              = "ELB"
  health_check_grace_period      = 300
  force_delete                   = true
  wait_for_capacity_timeout       = "0"
  
  target_group_arns = [aws_lb_target_group.app_alb_target_group.arn]
  
  tag {
      key                 = "Name"
      value               = "${var.infra_prefix}-app-asg"
      propagate_at_launch = true
    }
  depends_on = [
    aws_launch_template.template_app_LT
  ]
}




