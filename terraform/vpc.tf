# 1. The Virtual Private Cloud (Isolated Network)
resource "aws_vpc" "gitops_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "gitops-production-vpc"
  }
}

# 2. Public Subnet for internet-facing resources
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.gitops_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "gitops-public-subnet"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.gitops_vpc.id

  tags = {
    Name = "gitops-vpc-igw"
  }
}

# 4. Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.gitops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "gitops-public-rt"
  }
}

# 5. Associate Subnet with Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}