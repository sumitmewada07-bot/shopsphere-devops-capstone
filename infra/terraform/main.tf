# 1. Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "shopsphere-vpc"
    Project = "ShopSphere"
  }
}

# 2. Attach Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "shopsphere-igw"
    Project = "ShopSphere"
  }
}

# 3. Create 6 Subnets (2 Availability Zones)
# Public Subnets
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = { Name = "shopsphere-public-a", Project = "ShopSphere" }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.20.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = { Name = "shopsphere-public-b", Project = "ShopSphere" }
}

# Private Application Subnets
resource "aws_subnet" "private_app_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.20.11.0/24"
  availability_zone = "ap-south-1a"

  tags = { Name = "shopsphere-private-app-a", Project = "ShopSphere" }
}

resource "aws_subnet" "private_app_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.20.12.0/24"
  availability_zone = "ap-south-1b"

  tags = { Name = "shopsphere-private-app-b", Project = "ShopSphere" }
}

# Private Database Subnets
resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.20.21.0/24"
  availability_zone = "ap-south-1a"

  tags = { Name = "shopsphere-private-db-a", Project = "ShopSphere" }
}

resource "aws_subnet" "private_db_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.20.22.0/24"
  availability_zone = "ap-south-1b"

  tags = { Name = "shopsphere-private-db-b", Project = "ShopSphere" }
}

# 4. Route Tables
# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "shopsphere-public-rt", Project = "ShopSphere" }
}

# Private Route Table (No direct IGW route for security)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = { Name = "shopsphere-private-rt", Project = "ShopSphere" }
}

# 5. Associate Route Tables with Subnets
# Public Subnet Associations
resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# Private App Subnet Associations
resource "aws_route_table_association" "private_app_a_assoc" {
  subnet_id      = aws_subnet.private_app_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_app_b_assoc" {
  subnet_id      = aws_subnet.private_app_b.id
  route_table_id = aws_route_table.private.id
}

# Private DB Subnet Associations
resource "aws_route_table_association" "private_db_a_assoc" {
  subnet_id      = aws_subnet.private_db_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_b_assoc" {
  subnet_id      = aws_subnet.private_db_b.id
  route_table_id = aws_route_table.private.id
}

# 1. ALB Security Group (Public facing load balancer)
resource "aws_security_group" "alb_sg" {
  name        = "shopsphere-alb-sg"
  description = "Security group for ShopSphere ALB allowing HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  # Inbound Rule: Allow HTTPS (443) from anywhere (or change to approved CIDRs if needed)
  ingress {
    description = "Allow HTTPS from client CIDRs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rule: Allow all outbound traffic to ECS tasks / backend
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "shopsphere-alb-sg"
    Project = "ShopSphere"
  }
}

# 2. Application Security Group (ECS Fargate tasks)
resource "aws_security_group" "app_sg" {
  name        = "shopsphere-app-sg"
  description = "Security group for ShopSphere Application allowing traffic only from ALB"
  vpc_id      = aws_vpc.main.id

  # Inbound Rule: Allow traffic on application port (e.g., 80 or 3000/8080) ONLY from ALB security group
  ingress {
    description     = "Allow traffic from ALB"
    from_port       = 80 # Apne app ke port ke hisab se change kar sakte ho (jaise 3000 ya 8080)
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Outbound Rule: Allow all outbound traffic (for fetching packages, database connection, etc.)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "shopsphere-app-sg"
    Project = "ShopSphere"
  }
}

# 3. Database Security Group (RDS PostgreSQL)
resource "aws_security_group" "db_sg" {
  name        = "shopsphere-db-sg"
  description = "Security group for PostgreSQL database allowing traffic only from app SG"
  vpc_id      = aws_vpc.main.id

  # Inbound Rule: Allow PostgreSQL (5432) ONLY from application security group
  ingress {
    description     = "Allow PostgreSQL from application SG"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  tags = {
    Name    = "shopsphere-db-sg"
    Project = "ShopSphere"
  }
}

# 4. Admin Security Group (For Bastion or management instances if needed via SSM)
resource "aws_security_group" "admin_sg" {
  name        = "shopsphere-admin-sg"
  description = "Security group for administrative access, no public SSH"
  vpc_id      = aws_vpc.main.id

  # No public inbound rules for SSH (Port 22). Systems Manager (SSM) Session Manager uses outbound HTTPS.
  egress {
    description = "Allow all outbound traffic for SSM agent"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "shopsphere-admin-sg"
    Project = "ShopSphere"
  }
}