# Create Load Balancer (External ALB for Frontend)
resource "aws_lb" "frontend_alb" {
  name               = "frontend-alb"
  internal           = false  # Public-facing ALB
  load_balancer_type = "application"
  security_groups    = [var.frontend_sg_id]
  subnets            = var.public_subnets  # Public subnets
  enable_deletion_protection = false

  tags = {
    Name = "frontend-alb"
  }
}

# Create Target Group for Frontend EC2 instances
resource "aws_lb_target_group" "frontend_target_group" {
  name     = "frontend-instances"
  port     = 80  # HTTP port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/"
    port = 80
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    matcher = "200"
  }

  tags = {
    Name = "frontend-instances"
  }
}

# Create Listener for Frontend ALB (HTTP)
resource "aws_lb_listener" "frontend_http_listener" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }
}
