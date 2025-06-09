# === VPC Creation === #

resource "aws_vpc" "YAKOUT-VPC" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "SEIF-VPC"
  }
}

# === Public Subnets Creation === #

resource "aws_subnet" "public-subnet1" {
  vpc_id = aws_vpc.YAKOUT-VPC.id
  cidr_block = var.public-subnet1_cidr
  availability_zone = var.availability_zone_a
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet1"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id = aws_vpc.YAKOUT-VPC.id
  cidr_block = var.public-subnet2_cidr
  availability_zone = var.availability_zone_b
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet2"
  }
}


# === Private Subnets Creation === #

resource "aws_subnet" "private-subnet3" {
  vpc_id = aws_vpc.YAKOUT-VPC.id
  cidr_block = var.private-subnet3_cidr
  availability_zone = var.availability_zone_a
  map_public_ip_on_launch = false
  tags = {
    Name = "Private-Subnet3"
  }
}

resource "aws_subnet" "private-subnet4" {
  vpc_id = aws_vpc.YAKOUT-VPC.id
  cidr_block = var.private-subnet4_cidr
  availability_zone = var.availability_zone_b
  map_public_ip_on_launch = false
  tags = {
    Name = "Private-Subnet4"
  }
}

resource "aws_subnet" "private-subnet5" {
  vpc_id = aws_vpc.YAKOUT-VPC.id
  cidr_block = var.private-subnet5_cidr
  availability_zone = var.availability_zone_a
  map_public_ip_on_launch = false
  tags = {
    Name = "Private-Subnet5"
  }
}

resource "aws_subnet" "private-subnet6" {
  vpc_id = aws_vpc.YAKOUT-VPC.id
  cidr_block = var.private-subnet6_cidr
  availability_zone = var.availability_zone_b
  map_public_ip_on_launch = false
  tags = {
    Name = "Private-Subnet6"
  }
}


# === Internet Gateway Creation === #

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.YAKOUT-VPC.id
  tags = {
    Name = "SEIF-IGW"
  }
}

# === NAT Gateway & Elastic IP Creation === #

resource "aws_eip" "nat-eIP" {
  domain = "vpc"
  tags = {
    Name       = "SEIF-nat-eIP"
    Deployment = "Terraform"
  }
}

resource "aws_nat_gateway" "NAT-GW" {
  allocation_id = aws_eip.nat-eIP.id
  subnet_id     = aws_subnet.public-subnet2.id

  tags = {
    Name = "SEIF-NAT-GW"
    Deployment = "Terraform"
  }
}

# === Public Routing Table Creation === #

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.YAKOUT-VPC.id
  tags = {
    Name = "PublicRT"
  }
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public-subnet1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public-subnet2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

# === Private Routing Table Creation === #
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.YAKOUT-VPC.id
  tags = {
    Name = "PrivateRT"
  }
}

resource "aws_route" "NAT_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.NAT-GW.id
}

resource "aws_route_table_association" "private-subnet3" {
  subnet_id      = aws_subnet.private-subnet3.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private-subnet4" {
  subnet_id      = aws_subnet.private-subnet4.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private-subnet5" {
  subnet_id      = aws_subnet.private-subnet5.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private-subnet6" {
  subnet_id      = aws_subnet.private-subnet6.id
  route_table_id = aws_route_table.private_rt.id
}

