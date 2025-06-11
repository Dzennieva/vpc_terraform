
// This module creates a VPC with public and private subnets, an internet gateway, NAT gateways, and route tables.
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

// Creates an Internet Gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }

}

// Creates public subnets based on the provided CIDR blocks and availability zones
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

  map_public_ip_on_launch= true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

// Creates private subnets based on the provided CIDR blocks and availability zones
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  }

}

// Creates a route table for public subnets to route traffic to the internet gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  // Route to the internet gateway for public subnets
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

// Associates the public subnets with the public route table
resource "aws_route_table_association" "my_rta_public" {
  count = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
  
}

// Creates Elastic IPs for the NAT gateways
resource "aws_eip" "eip" {
  count = length(var.private_subnet_cidrs)
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  }
  
}

// Creates NAT gateways in the public subnets with the allocated Elastic IPs
resource "aws_nat_gateway" "ngw" {
  count = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name = "${var.project_name}-nat-${count.index + 1}"
  }
  depends_on = [aws_internet_gateway.igw]
  
}

// Creates route tables for private subnets to route traffic through the NAT gateways
resource "aws_route_table" "private_route_table" {
  count = length(aws_subnet.private_subnet)
  vpc_id = aws_vpc.my_vpc.id
  route  {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[count.index].id
  }
  tags = {
    Name = "${var.project_name}-private-route-table-${count.index + 1}"
  }
  
}

# Associates the private subnets with their respective route tables
resource "aws_route_table_association" "priv_rta" {
  count = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}
