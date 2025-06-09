# Create Load Balancer (Internal ALB for Backend)
resource "aws_lb" "backend_alb" {
  name               = "backend-alb"
  internal           = true  # Private-facing ALB (internal communication)
  load_balancer_type = "application"
  security_groups    = [var.backend_sg_id]
  subnets            = var.private_subnets # Private subnets
  enable_deletion_protection = false

  tags = {
    Name = "backend-alb"
  }
}

# Create Target Group for Backend EC2 instances
resource "aws_lb_target_group" "backend_target_group" {
  name     = "backend-instances"
  port     = 5050 
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/health"
    port = 5050
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    matcher = "200"
  }

  tags = {
    Name = "backend-instances"
  }
}

# Create Listener for Backend ALB (HTTP)
resource "aws_lb_listener" "backend_http_listener" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = 5050
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }
}
