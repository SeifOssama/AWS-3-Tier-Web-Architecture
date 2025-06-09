# === ROOT main.tf === #

# ---------------------------------------------------------------------
# Calling the VPC Module
# ---------------------------------------------------------------------
module "vpc" {
  source               = "./modules/VPC"
  vpc_cidr_block       = var.vpc_cidr_block
  public-subnet1_cidr  = var.public-subnet1_cidr
  public-subnet2_cidr  = var.public-subnet2_cidr
  private-subnet3_cidr = var.private-subnet3_cidr
  private-subnet4_cidr = var.private-subnet4_cidr
  private-subnet5_cidr = var.private-subnet5_cidr
  private-subnet6_cidr = var.private-subnet6_cidr
  availability_zone_a   = var.availability_zone_a
  availability_zone_b   = var.availability_zone_b
}


# ---------------------------------------------------------------------
# Calling the Security Group Modules
# ---------------------------------------------------------------------
module "bastion_sg" {
  source = "./modules/SecurityGroups"
  vpc-ID = module.vpc.vpc_id
  name = "bastion_sg"
  description = "This is bastion Security Group"
  ingress_rules = {
    icmp={
    cidr_ipv4                    = "0.0.0.0/0"
    referenced_security_group_id = null
    from_port                    = -1
    ip_protocol                  = "icmp"
    to_port                      = -1
    }
    ssh={
    cidr_ipv4                    = "0.0.0.0/0"
    referenced_security_group_id = null
    from_port                    = 22
    ip_protocol                  = "tcp"
    to_port                      = 22
    }
    http={
    cidr_ipv4                    = "0.0.0.0/0"
    referenced_security_group_id = null
    from_port                    = 80
    ip_protocol                  = "tcp"
    to_port                      = 80
    }
  }
  tags = {
    Name = "Bastion-SG"
  }
  }

module "frontend_sg" {
  source = "./modules/SecurityGroups"
  vpc-ID = module.vpc.vpc_id
  name = "frontend_sg"
  description = "This is Frontend Security Group"
  ingress_rules = {
    ssh={
    cidr_ipv4                    = null
    referenced_security_group_id = module.bastion_sg.securitygroup_id
    from_port                    = 22
    ip_protocol                  = "tcp"
    to_port                      = 22
    }
    http={
    cidr_ipv4                    = null
    referenced_security_group_id = module.externalALB_sg.securitygroup_id
    from_port                    = 80
    ip_protocol                  = "tcp"
    to_port                      = 80
    }
  }
  tags = {
    Name = "FrontEnd-SG"
  }
  }




module "backend_sg" {
  source = "./modules/SecurityGroups"
  vpc-ID = module.vpc.vpc_id
  name = "backend_sg"
  description = "This is Backend Security Group"
  ingress_rules = {
    ssh={
    cidr_ipv4                    = null
    referenced_security_group_id = module.bastion_sg.securitygroup_id
    from_port                    = 22
    ip_protocol                  = "tcp"
    to_port                      = 22
    }
    backapp={
    cidr_ipv4                    = null
    referenced_security_group_id = module.internalALB_sg.securitygroup_id
    from_port                    = 5050
    ip_protocol                  = "tcp"
    to_port                      = 5050
    }
  }
  tags = {
    Name = "BackEnd-SG"
  }
}

module "rds_sg" {
  source = "./modules/SecurityGroups"
  vpc-ID = module.vpc.vpc_id
  name = "rds_sg"
  description = "This is RDS Security Group"
  ingress_rules = {
    db={
    cidr_ipv4                    = null
    referenced_security_group_id = module.backend_sg.securitygroup_id
    from_port                    = 3306
    ip_protocol                  = "tcp"
    to_port                      = 3306
    }
    
  }
  tags = {
    Name = "RDS-SG"
  }
}

module "externalALB_sg" {
  source = "./modules/SecurityGroups"
  vpc-ID = module.vpc.vpc_id
  name = "ExternalALB_sg"
  description = "This is ExternalALB Security Group"
  ingress_rules = {
    frontend={
    cidr_ipv4                    = "0.0.0.0/0"
    referenced_security_group_id = null
    from_port                    = 80
    ip_protocol                  = "tcp"
    to_port                      = 80
    }
    
  }
  tags = {
    Name = "ExternalALB-SG"
  }
}

module "internalALB_sg" {
  source = "./modules/SecurityGroups"
  vpc-ID = module.vpc.vpc_id
  name = "InternalALB_sg"
  description = "This is InternalALB Security Group"
  ingress_rules = {
    frontend={
    cidr_ipv4                    = null
    referenced_security_group_id = module.frontend_sg.securitygroup_id
    from_port                    = 5050
    ip_protocol                  = "tcp"
    to_port                      = 5050
    }
    
  }
  tags = {
    Name = "InternalALB-SG"
  }
}

# === Bastion Host Setup Script ===#
module "bastion_host"{
  source = "./modules/EC2"
  public-subnet1 = module.vpc.public_subnet1_id #Passing VPC output to bastion host
  bastion_SG = module.bastion_sg.securitygroup_id
}


# === ASG Modules === #

module "frontend_asg" {
 source = "./modules/ASG/"
 public-subnet1 = module.vpc.public_subnet1_id
 public-subnet2 = module.vpc.public_subnet2_id
 frontend_SG = module.frontend_sg.securitygroup_id
 private-subnet3 = module.vpc.private_subnet3_id
 private-subnet4 = module.vpc.private_subnet4_id
 backend_SG = module.backend_sg.securitygroup_id
 RDS_HOSTNAME = local.RDS_HOSTNAME
 RDS_USERNAME = var.rds_username
 RDS_PASSWORD = var.rds_password
 backend_target_group = module.ALB.backend_target_group
 frontend_target_group = module.ALB.frontend_target_group
 depends_on = [module.ALB, module.rds_db]

 uservariable = base64encode(
 templatefile("${path.module}/modules/ASG/UserData/frontend.sh.tpl", {
 backend_alb_dns = module.ALB.backend_alb_dns
 })
 )
}

 locals {
  RDS_HOSTNAME = split(":", module.rds_db.db_endpoint)[0]
}

# module "backend_asg" {
#   source = "./modules/ASG/BackEnd-ASG.tf"
#   private-subnet3 = module.vpc.private_subnet3_id
#   private-subnet4 = module.vpc.private_subnet4_id
#   backend_SG = module.SecurityGroups.backend_sg_id
#   RDS_HOSTNAME = local.RDS_HOSTNAME
#   RDS_USERNAME = var.rds_username
#   RDS_PASSWORD = var.rds_password
#   depends_on =  [module.rds_db]

# }




# Calling the ALB Module and passing the VPC ID
module "ALB" {
  source              = "./modules/ALB"
  frontend_sg_id     = module.externalALB_sg.securitygroup_id
  public_subnets     = [module.vpc.public_subnet1_id, module.vpc.public_subnet2_id]
  backend_sg_id      = module.internalALB_sg.securitygroup_id
  private_subnets    = [module.vpc.private_subnet3_id, module.vpc.private_subnet4_id]
  vpc_id             = module.vpc.vpc_id # Pass VPC ID
}

# module "backend_alb" {
#   source              = "./modules/ALB/Internal-ALB.tf"
#   backend_sg_id      = module.backend_sg.backend_sg_id
#   private_subnets    = [module.vpc.private_subnet3_id, module.vpc.private_subnet4_id]
#   vpc_id             = module.vpc.vpc_id  # Pass VPC ID
# }



# DB Module

module "rds_db" {
  source= "./modules/RDS"
  dbusername = var.rds_username
  dbpassword = var.rds_password
  subnet_lists = [module.vpc.private_subnet5_id, module.vpc.private_subnet6_id]
  sg_lists = [ module.rds_sg.securitygroup_id ]
}