# modules/ec2/frontend_asg.tf

resource "aws_autoscaling_group" "FrontEnd_ASG" {
  desired_capacity     = 1
  min_size             = 1
  max_size             = 1
  name = "FrontEnd-ASG"
  target_group_arns = [var.frontend_target_group]
  vpc_zone_identifier  = [var.public-subnet1, var.public-subnet2]  # Public Subnets
  health_check_type          = "EC2"
  health_check_grace_period = 300
  force_delete               = true
    tag {
    key                 = "Name"
    value               = "FrontEnd-ASG"
    propagate_at_launch = true
  }
  
  
  launch_template {
    id = aws_launch_template.frontend_launch_template.id
    version = "$Latest"
  }

 lifecycle {
    create_before_destroy = true
  }

}
