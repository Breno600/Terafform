variable "region" {
  description = "This is Region Deployed"
  type = string
  default = "us-east-2"
}

variable "cidr-block-vpc" {
  description = "This is CIDR to VPC"
  type = string
  default = "10.232.44.0/22"
}

variable "name-vpc" {
  description = "This is Name to want to VPC"
  type = string
  default = "VPC-EKS"
}

variable "name-owner" {
  description = "This is the name Owner"
  type = string
  default = "Breno Kevin Xavier Silva"
}

variable "environment" {
  description = "This is Name the environment"
  type = string
  default = "Development"
}

variable "subnet-cidr-block-public-01" {
  type = string
  default = "10.232.44.128/25"
}

variable "subnet-cidr-block-public-02" {
  type = string
  default = "10.232.44.0/25"
}

variable "subnet-cidr-block-private-01" {
  type = string
  default = "10.232.46.0/24"
}

variable "subnet-cidr-block-private-02" {
  type = string
  default = "10.232.45.0/24"
}

variable "subnet-cidr-block-db-01" {
  type = string
  default = "10.232.47.128/25"
}

variable "subnet-cidr-block-db-02" {
  type = string
  default = "10.232.47.0/25"
}

variable "name-subnet-public-01" {
  type = string
  default = "SUB-PUBLIC-EKS-01"
}

variable "name-subnet-public-02" {
  type = string
  default = "SUB-PUBLIC-EKS-02"
}

variable "name-subnet-private-01" {
  type = string
  default = "SUB-PRIVATE-EKS-01"
}

variable "name-subnet-private-02" {
  type = string
  default = "SUB-PRIVATE-EKS-02"
}

variable "name-subnet-db-01" {
  type = string
  default = "SUB-DB-EKS-01"
}

variable "name-subnet-db-02" {
  type = string
  default = "SUB-DB-EKS-02"
}

variable "name-internet-gateway" {
  type = string
  default = "IGW-EKS"
}

variable "name-ngw" {
  type = string
  default = "NGW-EKS"
}

variable "name-nat" {
  type = string
  default = "NAT-EKS"
}

variable "name-route-table-private" {
  type = string
  default = "RT-PRIVATE-EKS"
}

variable "name-route-table-public" {
  type = string
  default = "RT-PUBLIC-EKS"
}

variable "cluster_name" {
  type = string
  default = "eks-hml"
}

variable "instance_type_eks" {
  type = string
  default = "t3a.medium"
}

variable "registry_username" {
  type = string
  default = "AIOIKIJASODIJASOIDJO"
}

variable "registry_password" {
  type = string
  default = "ASDASD\ASJKLDNASJDKASDASDASD"
}

variable "registry_email" {
  type = string
  default = "teste@banco.com.br"
}

