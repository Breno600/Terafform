terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source  = "./modules/vpc"

  cidr-block-vpc = "10.232.44.0/22"
  vpc-name = "VPC-EKS"
  owner = "Breno Kevin Xavier Silva"
  environment = "Development"

}
module "subnet" {
  source  = "./modules/subnet"

  #IDs
  vpcid = module.vpc.vpc_id

  #CIDRS
  cidr-block-public-01 = "10.232.44.128/25"
  cidr-block-public-02 = "10.232.44.0/25"
  cidr-block-private-01 = "10.232.46.0/24"
  cidr-block-private-02 = "10.232.45.0/24"
  cidr-block-db-01 = "10.232.47.128/25"
  cidr-block-db-02 = "10.232.47.0/25"

  #NAMES
  name-subnet-public-01 = "SUB-PUBLIC-EKS-01"
  name-subnet-public-02 = "SUB-PUBLIC-EKS-02"
  name-subnet-private-01 = "SUB-PRIVATE-EKS-01"
  name-subnet-private-02 = "SUB-PRIVATE-EKS-02"
  name-subnet-db-01 = "SUB-DB-EKS-01"
  name-subnet-db-02 = "SUB-DB-EKS-02"
  owner = "Breno Kevin Xavier Silva"
  environment = "Development" 

  depends_on=["module.vpc"]
}

module "internet-gateway" {
  source  = "./modules/internet-gateway"
  vpcid = module.vpc.vpc_id
  name-igw = "IGW-EKS"
  #TAGs
  owner = "Breno Kevin Xavier Silva"
  environment = "Development" 
  depends_on=["module.subnet"]
}

module "nat-gateway" {
  source  = "./modules/nat-gateway"

  #SUBNETs
  subnet-public = module.subnet.subnet_public_eks_01
  
  #NAMEs
  name-ngw = "NGW-EKS"
  name-nat = "NAT-EKS"

  #TAGs
  owner = "Breno Kevin Xavier Silva"
  environment = "Development" 

  depends_on=["module.subnet"]
}

module "route-table" {
  source  = "./modules/route-table"

  #IDs
  vpcid = module.vpc.vpc_id

  #SUBNETS
  subnet-public-eks-01 = module.subnet.subnet_public_eks_01
  subnet-public-eks-02 = module.subnet.subnet_public_eks_02
  subnet-private-eks-01 = module.subnet.subnet_private_eks_01
  subnet-private-eks-02 = module.subnet.subnet_private_eks_02
  subnet-db-eks-01 = module.subnet.subnet_db_eks_01
  subnet-db-eks-02 = module.subnet.subnet_db_eks_02

  #NAT GATEWAY
  nat-gateway = module.nat-gateway.nat_gateway_id

  #NAMES
  name-route-table-private = "RT-PRIVATE-EKS"
  name-route-table-public = "RT-PUBLIC-EKS"

  #TAGs
  owner = "Breno Kevin Xavier Silva"
  environment = "Development" 

  depends_on=["module.nat-gateway"]
}

module "eks" {
  depends_on=["module.nat-gateway"]
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.29.0"
  cluster_version = "1.21"
  cluster_name    = "eks-hml"
  vpc_id          = module.vpc.vpc_id
  subnet_ids        = [module.subnet.subnet_private_eks_01,module.subnet.subnet_private_eks_02]
  enable_irsa     = true
  cluster_enabled_log_types = [ "audit", "api", "authenticator" ]

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        }
      ]
    }
  }

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::761014375856:role/AWSServiceRoleForAmazonEKS"
      username = "AWSServiceRoleForAmazonEKS"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::761014375856:user/programatic"
      username = "programatic"
      groups   = ["system:masters"]
    }
  ]

  node_security_group_additional_rules = {
    ingress_nodes_karpenter_port = {
      description                   = "Cluster API to Node group for Karpenter webhook"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  node_security_group_tags = {
    "karpenter.sh/discovery/eks-hml" = "eks-hml"
  }

  tags = {
    "karpenter.sh/discovery" = "eks-hml"
  }
}

# module "karpenter_irsa" {
#   depends_on=["module.eks"]
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "5.3.1"

#   role_name                          = "karpenter-controller-eks-hml"
#   attach_karpenter_controller_policy = true

#   karpenter_tag_key               = "karpenter.sh/discovery/eks-hml"
#   karpenter_controller_cluster_id = module.eks.cluster_id
#   karpenter_controller_node_iam_role_arns = [
#     module.eks.eks_managed_node_groups["initial"].iam_role_arn
#   ]

#   oidc_providers = {
#     ex = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["karpenter:karpenter"]
#     }
#   }
# }

#module "ecr-image-private" {
#  source  = "./modules/eks/registry-image"
#  name-registry-private = "project-moc"
#}

