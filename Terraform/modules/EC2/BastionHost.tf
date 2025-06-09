# modules/ec2/bastion_host.tf

resource "aws_instance" "bastion_host" {
  ami           = "ami-02457590d33d576c3"  # Replace with your preferred AMI ID (Amazon Linux 2, Ubuntu, etc.)
  instance_type = "t2.micro"  # Use t2.micro for Free Tier
  subnet_id     = var.public-subnet1 # Choose an appropriate public subnet
  vpc_security_group_ids = [var.bastion_SG] # Attach the security group for SSH access
  user_data     = filebase64("./modules/EC2/config.sh")
  associate_public_ip_address = true
  tags = {
    Name = "Bastion Host"
  }

  
  
}


