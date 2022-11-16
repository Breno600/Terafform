# Creating Public Subnets in VPC
resource "aws_subnet" "SUB-PUBLIC-EKS-01" {
  vpc_id                  = var.vpcid
  cidr_block              = var.cidr-block-public-01
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"

  tags = {
    Name = var.name-subnet-public-01
    Owner = var.owner
    Tool = "Terraform"
    Environment = var.environment
  }
}

# Creating Public Subnets in VPC
resource "aws_subnet" "SUB-PUBLIC-EKS-02" {
  vpc_id                  = var.vpcid
  cidr_block              = var.cidr-block-public-02
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags = {
    Name = var.name-subnet-public-01
    Owner = var.owner
    Tool = "Terraform"
    Environment = var.environment
  }
}

# Creating PRIVATES Subnets in VPC
resource "aws_subnet" "SUB-PRIVATE-EKS-01" {
  vpc_id                  = var.vpcid
  cidr_block              = var.cidr-block-private-01
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"

  tags = {
    Name = var.name-subnet-public-01
    Owner = var.owner
    Tool = "Terraform"
    Environment = var.environment
  }
}

# Creating PRIVATE Subnets in VPC
resource "aws_subnet" "SUB-PRIVATE-EKS-02" {
  vpc_id                  = var.vpcid
  cidr_block              = var.cidr-block-private-02
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags = {
    Name = var.name-subnet-public-01
    Owner = var.owner
    Tool = "Terraform"
    Environment = var.environment
  }
}

# Creating DB Subnets in VPC
resource "aws_subnet" "SUB-DB-EKS-01" {
  vpc_id                  = var.vpcid
  cidr_block              = var.cidr-block-db-01 
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"

  tags = {
    Name = var.name-subnet-db-01
    Owner = var.owner
    Tool = "Terraform"
    Environment = var.environment
  }
}

# Creating DB Subnets in VPC
resource "aws_subnet" "SUB-DB-EKS-02" {
  vpc_id                  = var.vpcid
  cidr_block              = var.cidr-block-db-02 
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags = {
    Name = var.name-subnet-db-01
    Owner = var.owner
    Tool = "Terraform"
    Environment = var.environment
  }
}

output "subnet_public_eks_01" {
  value = aws_subnet.SUB-PUBLIC-EKS-01.id
}

output "subnet_public_eks_02" {
  value = aws_subnet.SUB-PUBLIC-EKS-02.id
}

output "subnet_private_eks_01" {
  value = aws_subnet.SUB-PRIVATE-EKS-01.id
}

output "subnet_private_eks_02" {
  value = aws_subnet.SUB-PRIVATE-EKS-02.id
}

output "subnet_db_eks_01" {
  value = aws_subnet.SUB-DB-EKS-01.id
}

output "subnet_db_eks_02" {
  value = aws_subnet.SUB-DB-EKS-02.id
}