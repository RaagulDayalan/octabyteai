// vpc
resource "aws_vpc" "template_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.infra_prefix}-vpc"
    
    
  }
}

resource "aws_subnet" "template_priv_sub1" {
  vpc_id                  = aws_vpc.template_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zone_1
  tags = {
    Name = "${var.infra_prefix}-priv-sub1"
        
    
  }
}

resource "aws_subnet" "template_priv_sub2" {
  vpc_id                  = aws_vpc.template_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.availability_zone_2
  tags = {
    Name = "${var.infra_prefix}-priv-sub2"
        
    
  }
}

resource "aws_subnet" "template_pub_sub1" {
  vpc_id                  = aws_vpc.template_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = var.availability_zone_1
  tags = {
    Name = "${var.infra_prefix}-pub-sub1"
        
    
  }
}

resource "aws_subnet" "template_pub_sub2" {
  vpc_id                  = aws_vpc.template_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = var.availability_zone_2
  tags = {
    Name = "${var.infra_prefix}-pub-sub2"
        
    
  }
}

//public RT
resource "aws_internet_gateway" "template_IG" {
  vpc_id = aws_vpc.template_vpc.id
    tags = {
    Name = "${var.infra_prefix}-Igw"
        
    
  }
}

resource "aws_route_table" "template_public_RT" {
  vpc_id = aws_vpc.template_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.template_IG.id
  }
  tags = {
    Name = "${var.infra_prefix}-pub-rt"
        
    
  }
}

resource "aws_route_table_association" "template_public_RT_association" {
  subnet_id      = aws_subnet.template_pub_sub2.id
  route_table_id = aws_route_table.template_public_RT.id
}

resource "aws_route_table_association" "template_public2_RT_association" {
  subnet_id      = aws_subnet.template_pub_sub1.id
  route_table_id = aws_route_table.template_public_RT.id
}

// private RT
resource "aws_eip" "template_NATG_eip" {
  domain       = "vpc"
}

resource "aws_nat_gateway" "template_NATG" {
  allocation_id = aws_eip.template_NATG_eip.id
  subnet_id     = aws_subnet.template_pub_sub1.id

  tags = {
    Name = "${var.infra_prefix}-NAT-gw"
        
    
  }

  depends_on = [aws_internet_gateway.template_IG]
}

resource "aws_route_table" "template_private_RT" {
  vpc_id = aws_vpc.template_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.template_NATG.id
  }
  tags = {
    Name = "${var.infra_prefix}-priv-rt"
        
    
  }
}

resource "aws_route_table_association" "template_private_RT_association" {
  subnet_id      = aws_subnet.template_priv_sub2.id
  route_table_id = aws_route_table.template_private_RT.id
}

resource "aws_route_table_association" "template_private2_RT_association" {
  subnet_id      = aws_subnet.template_priv_sub1.id
  route_table_id = aws_route_table.template_private_RT.id
}


