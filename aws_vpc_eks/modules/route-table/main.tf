# Creating Route Tables for Internet gateway
resource "aws_route_table" "RT-PRIVATE-EKS" {
  vpc_id = var.vpcid
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat-gateway
  }

  tags = {
    Name = var.name-route-table-private
    Owner = var.owner
    Tool = "Terraform"
    Environment = var.environment
  }
}

# Creating Route Associations PRIVATE subnets
resource "aws_route_table_association" "RT-PRIVATE-EKS-1-a" {
  subnet_id      = var.subnet-private-eks-01
  route_table_id = aws_route_table.RT-PRIVATE-EKS.id
}

resource "aws_route_table_association" "RT-PRIVATE-EKS-2-a" {
  subnet_id      = var.subnet-private-eks-02
  route_table_id = aws_route_table.RT-PRIVATE-EKS.id
}

resource "aws_route_table_association" "RT-DB-EKS-1-a" {
  subnet_id      = var.subnet-db-eks-01
  route_table_id = aws_route_table.RT-PRIVATE-EKS.id
}

resource "aws_route_table_association" "RT-DB-EKS-2-a" {
  subnet_id      = var.subnet-db-eks-02
  route_table_id = aws_route_table.RT-PRIVATE-EKS.id
}

################################################################33


# Creating Route Tables for Internet gateway
resource "aws_route_table" "RT-PUBLIC-EKS" {
  vpc_id = var.vpcid
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat-gateway
  }

  tags = {
    Name = var.name-route-table-public
    Owner = var.owner
    Tool = "Terraform"
    Environment = var.environment
  }
}

# Creating Route Associations public subnets
resource "aws_route_table_association" "RT-PUBLIC-EKS-1-a" {
  subnet_id      = var.subnet-public-eks-01
  route_table_id = aws_route_table.RT-PUBLIC-EKS.id
}

resource "aws_route_table_association" "RT-PUBLIC-EKS-2-a" {
  subnet_id      = var.subnet-public-eks-02
  route_table_id = aws_route_table.RT-PUBLIC-EKS.id
}