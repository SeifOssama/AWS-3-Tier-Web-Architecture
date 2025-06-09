variable "dbusername" {
  type = string
  sensitive = true
}

variable "dbpassword" {
  type = string
  sensitive = true
}


variable "subnet_lists" {
  type = list(string)
}

variable "sg_lists" {
    type = list(string)
}