variable "nat-gateway" {
  type = string
}

variable "subnet-public-eks-01" {
  type = string
}
variable "subnet-public-eks-02" {
  type = string
}

variable "subnet-private-eks-01" {
  type = string
}

variable "subnet-private-eks-02" {
  type = string
}

variable "subnet-db-eks-01" {
  type = string
}

variable "subnet-db-eks-02" {
  type = string
}

variable "vpcid" {
  type = string
}

variable "name-route-table-private" {
  type = string
}

variable "owner" {
  type = string
}

variable "environment" {
  type = string
}

variable "name-route-table-public" {
  type = string
}