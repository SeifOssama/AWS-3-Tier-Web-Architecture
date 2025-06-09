# === ROOT Variables === #

# Variable for VPC CIDR block
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

# Public Subnet CIDR blocks
variable "public-subnet1_cidr" {
  description = "CIDR block for Public Subnet 1"
  default     = "10.0.1.0/24"
}

variable "public-subnet2_cidr" {
  description = "CIDR block for Public Subnet 2"
  default     = "10.0.2.0/24"
}

# Private Subnet CIDR blocks
variable "private-subnet3_cidr" {
  description = "CIDR block for Private Subnet 3"
  default     = "10.0.3.0/24"
}

variable "private-subnet4_cidr" {
  description = "CIDR block for Private Subnet 4"
  default     = "10.0.4.0/24"
}

variable "private-subnet5_cidr" {
  description = "CIDR block for Private Subnet 5"
  default     = "10.0.5.0/24"
}

variable "private-subnet6_cidr" {
  description = "CIDR block for Private Subnet 6"
  default     = "10.0.6.0/24"
}

# Availability Zones
variable "availability_zone_a" {
  description = "Availability Zone for Public Subnet A"
  default     = "us-east-1a"
}

variable "availability_zone_b" {
  description = "Availability Zone for Public Subnet B"
  default     = "us-east-1b"
}

# === RDS Variables ====

variable "rds_username" {
  type = string
  sensitive = true
}

variable "rds_password" {
  type = string
  sensitive = true
}

