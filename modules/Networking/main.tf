# VPC Definition
resource "aws_vpc" "main-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main-vpc"
    env  = "dev"
  }
}

# Internet Gateway Definition
resource "aws_internet_gateway" "main-internet-gateway" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "dev-igw"
    env  = "dev"
  }
}

# Public-Subnet-A Definition
resource "aws_subnet" "public-subnet-a" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-a"
    env  = "dev"
  }
}

# Public-Subnet-B Definition
resource "aws_subnet" "public-subnet-b" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-b"
    env  = "dev"
  }
}

# Private-Subnet-A Definition
resource "aws_subnet" "private-subnet-a" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-a"
    env  = "dev"
  }
}

# Private-Subnet-A Definition
resource "aws_subnet" "private-subnet-b" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-b"
    env  = "dev"
  }
}

# Elastic IP Definition for Nat Gateway
resource "aws_eip" "nat-gw-eip" {
  vpc = true
  depends_on = [
    aws_internet_gateway.main-internet-gateway
  ]
}

# NAT Gateway Definition
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-gw-eip.id
  subnet_id     = aws_subnet.public-subnet-a.id
  depends_on = [
    aws_internet_gateway.main-internet-gateway
  ]
  tags = {
    Name = "nat-gw"
    env  = "dev"
  }
}

# Route table definition for private subnets
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "private-route-table"
    env  = "dev"
  }
}

# Route table definition for public subnets
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "public-route-table"
    env  = "dev"
  }
}

# Public Routes for Internet Connection
resource "aws_route" "public-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main-internet-gateway.id
}

# Private Routes for Internet Connection
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
}

# Public-Subnet-A Route Table Association
resource "aws_route_table_association" "public-subnet-a-association" {
  subnet_id      = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.public-route-table.id
}

# Public-Subnet-B Route Table Association
resource "aws_route_table_association" "public-subnet-b-association" {
  subnet_id      = aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.public-route-table.id
}

# Private-Subnet-A Route Table Association
resource "aws_route_table_association" "private-subnet-a-association" {
  subnet_id      = aws_subnet.private-subnet-a.id
  route_table_id = aws_route_table.private-route-table.id
}

# Private-Subnet-B Route Table Association
resource "aws_route_table_association" "private-subnet-b-association" {
  subnet_id      = aws_subnet.private-subnet-b.id
  route_table_id = aws_route_table.private-route-table.id
}

# Security Group Definition
resource "aws_security_group" "EKS-Cluster-SG" {
  name = "EKS-Cluster-SG"
  vpc_id = aws_vpc.main-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

