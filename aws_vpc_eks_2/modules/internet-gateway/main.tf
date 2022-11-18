resource "aws_internet_gateway" "IGW-EKS" {
  vpc_id = var.vpcid

  tags = {
    Name = var.name-igw
    Owner = var.owner
    Tool = "Terraform"
    Environment = var.environment
  }
}