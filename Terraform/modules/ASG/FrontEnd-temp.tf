

# modules/ec2/frontend_launch_template.tf

resource "aws_launch_template" "frontend_launch_template" {
  name_prefix   = "FrontEnd-EC2"
  image_id      = "ami-0731becbf832f281e"  # Replace with your preferred AMI ID (Ubuntu, Amazon Linux, etc.)
  instance_type = "t2.micro"  # Use t2.micro for Free Tier
  vpc_security_group_ids = [var.frontend_SG]
 key_name = "frontend-instances"  # Associate the generated key pair

 user_data = var.uservariable

  lifecycle {
    create_before_destroy = true
  }
}

