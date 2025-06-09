resource "aws_db_instance" "rds_db" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.dbusername
  password             = var.dbpassword
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds_db_subnetgroup.name
  vpc_security_group_ids = var.sg_lists
}


resource "aws_db_subnet_group" "rds_db_subnetgroup" {
  name       = "main"
  subnet_ids = var.subnet_lists

  tags = {
    Name = "My DB subnet group"
  }
}