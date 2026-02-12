#Application load balancer for app server
resource "aws_lb" "webservers-load-balancer" {
  count = var.create_lb == true ? 1:0
  name               = "${var.env}-ems-webservers-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.webservers-alb-sg-id]
  subnets            = [var.public_subnet-1_id, var.public_subnet-2_id]
}

# Add Target Group
resource "aws_lb_target_group" "load-balancer-target-group" {
  name     = "${var.env}-ems-lb-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/actuator/health"
  }
  tags = {
    name= "${var.env}-ems-lb-target-group"
  }
}

# locals { lb_arn = var.create_lb ? aws_lb.webservers-load-balancer[0].arn : null }
locals { lb_dns_name = var.create_lb ? aws_lb.webservers-load-balancer[0].dns_name : null }

# Adding HTTP listener
resource "aws_lb_listener" "webserver_listner" {
  count = var.create_lb == true ? 1:0
  
  load_balancer_arn = aws_lb.webservers-load-balancer[0].arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.load-balancer-target-group.arn
    type             = "forward"
  }
}

