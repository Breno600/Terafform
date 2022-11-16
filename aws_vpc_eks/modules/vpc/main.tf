
# Creating VPC,name, CIDR and Tags
resource "aws_vpc" "VPC-EKS" {
  cidr_block           = var.cidr-block-vpc
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  
  tags = {
    Name = var.vpc-name
    Owner = var.owner
    Tool = "Terraform"
    Environment = var.environment
  }
}

output "vpc_id" {
  value = aws_vpc.VPC-EKS.id
}