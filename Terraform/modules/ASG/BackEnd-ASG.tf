# modules/ec2/frontend_asg.tf
resource "aws_autoscaling_group" "BackEnd_ASG" {
  desired_capacity     = 1
  min_size             = 1
  max_size             = 1
  name = "BackEnd-ASG"
  target_group_arns =[var.backend_target_group] 
  vpc_zone_identifier  = [ var.private-subnet3, var.private-subnet4]  # Private Subnets
  health_check_type          = "EC2"
  health_check_grace_period = 300
  force_delete               = true
    tag {
    key                 = "Name"
    value               = "BackEnd-ASG"
    propagate_at_launch = true
  }
  
  
  launch_template {
    id = aws_launch_template.backend_launch_template.id
    version = "$Latest"
  }

 lifecycle {
    create_before_destroy = true
  }

}
