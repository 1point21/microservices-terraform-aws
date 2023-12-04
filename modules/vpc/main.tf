### VPC AND SUBNETS ###

# CREATE VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "${var.project_name}-main-vpc"
    ManagedBy = "Terraform"
  }
}

# CREATE PUBLIC SUBNETS
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]

 tags = {
    Name = "${var.project_name}-pub-subnet-${count.index}"
    ManagedBy = "Terraform"
  }
}

# CREATE PRIVATE SUBNETS
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]

 tags = {
    Name = "${var.project_name}-priv-subnet-${count.index}"
    ManagedBy = "Terraform"
  }
}

### ROUTES AND ROUTETABLES ###

# CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-igw"
    ManagedBy = "Terraform"
  }
}

# CREATE PUBLIC ROUTE TABLE
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.main.id
  
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.igw.id
    }

  tags = {
    Name = "${var.project_name}-public-rt"
    ManagedBy = "Terraform"
  }
}

# ASSOCIATE SUBNETS WITH ROUTE TABLE
resource "aws_route_table_association" "public_routes" {
  count = length(var.public_subnet_cidr)
  route_table_id = aws_route_table.pub_rt.id
  subnet_id = aws_subnet.public_subnet[count.index].id
}