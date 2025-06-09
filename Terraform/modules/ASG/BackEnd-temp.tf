# Generate SSH Key Pair for Frontend EC2 instances


# modules/ec2/backend_launch_template.tf

resource "aws_launch_template" "backend_launch_template" {
  name_prefix   = "BackEnd-EC2"
  image_id      = "ami-0731becbf832f281e"  # Replace with your preferred AMI ID (Ubuntu, Amazon Linux, etc.)
  instance_type = "t2.micro"  # Use t2.micro for Free Tier
  vpc_security_group_ids = [var.backend_SG]
  key_name = "backend-instances"  # Associate the generated key pair

  user_data = base64encode(data.template_file.backend_user_data.rendered)
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "backend_user_data" {
  template = file("./modules/ASG/UserData/backend.sh.tpl")
  vars = {
  RDS_HOSTNAME = var.RDS_HOSTNAME
  RDS_USERNAME=  var.RDS_USERNAME
  RDS_PASSWORD = var.RDS_PASSWORD
  }
}