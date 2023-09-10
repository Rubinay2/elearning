
#Create VPC
resource "aws_vpc" "e-learning" {
  cidr_block           = var.vpc-cidr-block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# Declare the data sourceï
data "aws_availability_zones" "eaz" {
  state = "available"
}

#Create  subnetPublic1
resource "aws_subnet" "public_subnets" {
  count                                       = length(var.public_subnets_cidr)
  vpc_id                                      = aws_vpc.e-learning.id
  cidr_block                                  = var.public_subnets_cidr[count.index]
  availability_zone                           = var.availability_zone[count.index]
  map_public_ip_on_launch                     = var.map_public_ip_on_launch
  enable_resource_name_dns_a_record_on_launch = var.enable_resource_name_dns_a_record_on_launch

  tags = {
    Name = "${var.descriptor1}-public-subnet-${count.index + 1}"
  }
}

#Create Private subnet1
resource "aws_subnet" "private_subnets" {
  count                                       = length(var.private_subnets_cidr)
  vpc_id                                      = aws_vpc.e-learning.id
  cidr_block                                  = var.private_subnets_cidr[count.index]
  availability_zone                           = var.availability_zone[count.index]
  map_public_ip_on_launch                     = var.map_public_ip_on_launch
  enable_resource_name_dns_a_record_on_launch = var.enable_resource_name_dns_a_record_on_launch

  tags = {
    Name = "${var.descriptor2}-private-subnet-${count.index + 1}"
  }
}


#Internet Gateway
resource "aws_internet_gateway" "e-learningIGW" {
  vpc_id = aws_vpc.e-learning.id

  tags = {
    Name = "${var.project_name}-${var.environment}-internet-gateway"
  }
}

#Create elastic IP
resource "aws_eip" "e-learning-eip" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-elastic-iP"

  }
}

#NAT Gateway
resource "aws_nat_gateway" "e-learningNGW" {
  allocation_id = aws_eip.e-learning-eip.id
  subnet_id     = aws_subnet.public_subnets[1].id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.e-learningIGW]
}

#Public Route Table 
resource "aws_route_table" "e-learningPubRT" {
  vpc_id = aws_vpc.e-learning.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.e-learningIGW.id
  }
  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

#Private Route Table 
resource "aws_route_table" "e-learningPrivRT" {
  vpc_id = aws_vpc.e-learning.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.e-learningNGW.id
  }
  tags = {
    Name = "private route table"
  }

}

#Route table association -Public subnet 1
resource "aws_route_table_association" "Rt-assoc-pub-subnet1" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.e-learningPubRT.id
}


#Route table association -Private subnet 1
resource "aws_route_table_association" "Rt-assoc-priv-subnet1" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.e-learningPrivRT.id
}







