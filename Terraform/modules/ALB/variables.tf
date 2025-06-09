# variables.tf

variable "frontend_sg_id" {
  description = "Security Group ID for the Frontend EC2 instances"
  type        = string
}

variable "backend_sg_id" {
  description = "Security Group ID for the Backend EC2 instances"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for External ALB"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs for Internal ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where the resources are located"
  type        = string
}