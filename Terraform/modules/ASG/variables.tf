variable "frontend_target_group" {
  type = string
}

variable "backend_target_group" {
  type = string
}
variable "public-subnet1" {
  type = string
  description = "ID of Private Subnet 3"
}

variable "public-subnet2" {
  type = string
  description = "ID of Private Subnet 4"
}


variable "frontend_SG" {
  type = string
  
}

variable "backend_SG" {
  type = string
  
}


variable "RDS_HOSTNAME" {
  type = string
}

variable "RDS_USERNAME" {
  type = string
}

variable "RDS_PASSWORD" {
  type = string
}

variable "private-subnet3" {
  description = "ID of Private Subnet 3"
  type = string
}

variable "private-subnet4" {
  description = "ID of Private Subnet 4"
  type = string
}

variable "uservariable"{
  type = string
}