# ---------------------------------------------------------------------
# Outputs - Displaying Important Information after Terraform Apply
# ---------------------------------------------------------------------
# modules/vpc/outputs.tf

output "vpc_id" {
  value = aws_vpc.YAKOUT-VPC.id
}

output "public_subnet1_id" {
  value = aws_subnet.public-subnet1.id
}

output "public_subnet2_id" {
  value = aws_subnet.public-subnet2.id
}

output "private_subnet3_id" {
  value = aws_subnet.private-subnet3.id
}

output "private_subnet4_id" {
  value = aws_subnet.private-subnet4.id
}

output "private_subnet5_id" {
  value = aws_subnet.private-subnet5.id
}

output "private_subnet6_id" {
  value = aws_subnet.private-subnet6.id
}
