# --- VPCs ---
resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidrs["vpc1"]
  enable_dns_hostnames = true
  tags = { 
    Name = "test-vpc-1" 
  }
}

resource "aws_vpc" "vpc2" {
  cidr_block           = var.vpc_cidrs["vpc2"]
  enable_dns_hostnames = true
  tags = { 
    Name = "test-vpc-2" 
  }
}

resource "aws_vpc" "vpc3" {
  cidr_block           = var.vpc_cidrs["vpc3"]
  enable_dns_hostnames = true
  tags = { 
    Name = "test-vpc-3" 
  }
}

# --- Subnets ---
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.subnet_cidrs["subnet1"]
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = { 
    Name = "test-subnet-vpc-1-1a" 
  }
}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = var.subnet_cidrs["subnet2"]
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = { 
    Name = "test-subnet-vpc-2-1a" 
  }
}

resource "aws_subnet" "sub3" {
  vpc_id                  = aws_vpc.vpc3.id
  cidr_block              = var.subnet_cidrs["subnet3"]
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = { 
    Name = "test-subnet-vpc-3-1a" 
  }
}

# --- Internet Gateways ---
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id
  tags   = { Name = "Igw-test-vpc-1" }
}

resource "aws_internet_gateway" "igw2" {
  vpc_id = aws_vpc.vpc2.id
  tags   = { Name = "Igw-test-vpc-2" }
}

resource "aws_internet_gateway" "igw3" {
  vpc_id = aws_vpc.vpc3.id
  tags   = { Name = "Igw-test-vpc-3" }
}

# --- Transit Gateway & Attachments ---
resource "aws_ec2_transit_gateway" "tgw" {
  tags = { 
    Name = "Tg-vpc-1-vpc-2-vpc-3" 
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "att1" {
  subnet_ids         = [aws_subnet.sub1.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc1.id
  tags               = { Name = "Tg-attachment-vpc-1" }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "att2" {
  subnet_ids         = [aws_subnet.sub2.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc2.id
  tags               = { Name = "Tg-attachment-vpc-2" }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "att3" {
  subnet_ids         = [aws_subnet.sub3.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc3.id
  tags               = { Name = "Tg-attachment-vpc-3" }
}

# --- Route Tables ---
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = { Name = "Rt-test-vpc-1" }
}

resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw2.id
  }
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = { Name = "Rt-test-vpc-2" }
}

resource "aws_route_table" "rt3" {
  vpc_id = aws_vpc.vpc3.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw3.id
  }
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = { Name = "Rt-test-vpc-3" }
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt2.id
}

resource "aws_route_table_association" "a3" {
  subnet_id      = aws_subnet.sub3.id
  route_table_id = aws_route_table.rt3.id
}

# --- Security Groups ---
resource "aws_security_group" "sg1" {
  vpc_id = aws_vpc.vpc1.id
  name   = "allow_ssh_http_vpc1"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

resource "aws_security_group" "sg2" {
  vpc_id = aws_vpc.vpc2.id
  name   = "allow_ssh_http_vpc2"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

resource "aws_security_group" "sg3" {
  vpc_id = aws_vpc.vpc3.id
  name   = "allow_ssh_http_vpc3"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

# --- EC2 Instances ---
resource "aws_instance" "ec2_1" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.sub1.id
  vpc_security_group_ids = [aws_security_group.sg1.id]
  key_name               = var.key_name
  tags                   = { Name = "EC2-test-vpc-1" }
}

resource "aws_instance" "ec2_2" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.sub2.id
  vpc_security_group_ids = [aws_security_group.sg2.id]
  key_name               = var.key_name
  tags                   = { Name = "EC2-test-vpc-2" }
}

resource "aws_instance" "ec2_3" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.sub3.id
  vpc_security_group_ids = [aws_security_group.sg3.id]
  key_name               = var.key_name
  tags                   = { Name = "EC2-test-vpc-3" }
}
