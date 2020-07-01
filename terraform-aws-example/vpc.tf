# ##################################################
# ## Virtual Private Cloud
# ##################################################
#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
}

# Subnets
resource "aws_subnet" "private" {
  count                   = 3
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_cidr_block[count.index]
  map_public_ip_on_launch = "false"
  availability_zone       = var.az[count.index]
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_cidr_block[count.index]
  map_public_ip_on_launch = "false"
  availability_zone       = var.az[count.index]
}

# Internet GW
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_eip" "this" {
  vpc = true
}
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public.*.id[0]
}


# # route tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
}


resource "aws_route_table_association" "private_rt_association" {
  count = 3

  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "public_rt_association" {
  count          = 2
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}