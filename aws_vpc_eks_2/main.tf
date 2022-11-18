terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}

provider "aws" {
  region = "var.region"
}

module "vpc" {
  source  = "./modules/vpc"

  cidr-block-vpc        = var.cidr-block-vpc
  vpc-name              = var.name-vpc
  owner                 = var.name-owner
  environment           = var.environment

}
module "subnet" {
  source                = "./modules/subnet"

  #IDs
  vpcid                 = module.vpc.vpc_id

  #CIDRS
  cidr-block-public-01  = var.subnet-cidr-block-public-01
  cidr-block-public-02  = var.subnet-cidr-block-public-02
  cidr-block-private-01 = var.subnet-cidr-block-private-01
  cidr-block-private-02 = var.subnet-cidr-block-private-02
  cidr-block-db-01      = var.subnet-cidr-block-db-01
  cidr-block-db-02      = var.subnet-cidr-block-db-02

  #NAMES
  name-subnet-public-01   = var.name-subnet-public-01
  name-subnet-public-02   = var.name-subnet-public-02
  name-subnet-private-01  = var.name-subnet-private-01
  name-subnet-private-02  = var.name-subnet-private-02
  name-subnet-db-01 = var.name-subnet-db-01
  name-subnet-db-02 = var.name-subnet-db-02
  owner = var.name-owner
  environment = var.environment
  cluster-name = module.eks.cluster_name

  depends_on=["module.vpc"]
}

module "internet-gateway" {
  source  = "./modules/internet-gateway"
  vpcid = module.vpc.vpc_id
  name-igw = var.name-internet-gateway
  #TAGs
  owner = var.name-owner
  environment = var.environment
  depends_on=["module.subnet"]
}

module "nat-gateway" {
  source  = "./modules/nat-gateway"

  #SUBNETs
  subnet-public = module.subnet.subnet_public_eks_01
  
  #NAMEs
  name-ngw = var.name-ngw
  name-nat = var.name-nat

  #TAGs
  owner = var.name-owner
  environment = var.environment

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
  name-route-table-private = var.name-route-table-private
  name-route-table-public = var.name-route-table-public

  #TAGs
  owner = var.name-owner
  environment = var.environment

  depends_on=["module.nat-gateway"]
}

module "eks" {
  depends_on=["module.nat-gateway"] 
  source          = "terraform-aws-modules/eks/aws"
  version         = "<18"

  cluster_version = "1.21"
  cluster_name    = var.cluster_name
  vpc_id          = module.vpc.vpc_id
  subnets         = [var.subnet-cidr-block-private-01, var.subnet-cidr-block-private-02]
  enable_irsa     = true
  create_cloudwatch_log_group = true
  cluster_enabled_log_types = ["audit","api","authenticator","controllerManager","scheduler"]
  cloudwatch_log_group_retention_in_days = 7
  
  worker_groups = [
    {
      instance_type = var.instance_type_eks
      asg_max_size  = 1
    }
  ]

  tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }
}

data "aws_iam_policy" "ssm_managed_instance" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "karpenter_ssm_policy" {
  depends_on=["module.eks"]
  role       = module.eks.worker_iam_role_name
  policy_arn = data.aws_iam_policy.ssm_managed_instance.arn
}

resource "aws_iam_instance_profile" "karpenter" {
  depends_on=["module.eks"]
  name = "KarpenterNodeInstanceProfile-${var.cluster_name}"
  role = module.eks.worker_iam_role_name
}

module "iam_assumable_role_karpenter" {
  depends_on=["module.eks"]
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.7.0"
  create_role                   = true
  role_name                     = "karpenter-controller-${var.cluster_name}"
  provider_url                  = module.eks.cluster_oidc_issuer_url
  oidc_fully_qualified_subjects = ["system:serviceaccount:karpenter:karpenter"]
}

resource "aws_iam_role_policy" "karpenter_controller" {
  depends_on=["module.eks"]
  name = "karpenter-policy-${var.cluster_name}"
  role = module.iam_assumable_role_karpenter.iam_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:RunInstances",
          "ec2:CreateTags",
          "iam:PassRole",
          "ec2:TerminateInstances",
          "ec2:DescribeLaunchTemplates",
          "ec2:DeleteLaunchTemplate",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ssm:GetParameter"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "helm_release" "karpenter" {
  depends_on       = [module.eks.kubeconfig]
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.6.3"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_karpenter.iam_role_arn
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "clusterEndpoint"
    value = module.eks.cluster_endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }
}

module "external_secrets" {
  depends_on=["module.karpenter"]
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-external-secrets.git?ref=0.1.2"

  enabled = true

  cluster_name                     = module.eks.cluster_id
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  secrets_aws_region               = data.aws_region.current.name
}

module "load_balancer_controller" {
  depends_on=["module.karpenter"]
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-lb-controller.git"

  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  cluster_name                     = module.eks.cluster_id
}

module "container-insights" {
  source       = "Young-ook/eks/aws//modules/container-insights"
  cluster_name = var.cluster_name
  oidc         = module.eks.oidc_provider
  
  tags         = {
     owner = var.name-owner
     environment = var.environment
  }
}

#                                                       aws ecr get-login --region us-west-2
#resource "kubernetes_secret_v1" "config-ecr-in-eks" {
#  metadata {
#    name = "secret-ecr"
#  }
#
#  type = "kubernetes.io/dockerconfigjson"
#
#  data = {
#    ".dockerconfigjson" = jsonencode({
#      auths = {
#        "${var.registry_server}" = {
#          "username" = var.registry_username
#          "password" = var.registry_password
#          "email"    = var.registry_email
#          "auth"     = base64encode("${var.registry_username}:${var.registry_password}")
#        }
#      }
#    })
#  }
#}





#  data "aws_ecr_authorization_token" "token" {
#    proxy_endpoint      = "https://894711206975.dkr.ecr.us-east-2.amazonaws.com"
#    authorization_token =  ""
#  }
#  
#  resource "kubernetes_secret" "permission-ecr" {
#    metadata {
#      name      = "secret-ecr"
#      namespace = "default"
#    }
#  
#    data = {
#      ".dockerconfigjson" = jsonencode({
#        auths = {
#          "${data.aws_ecr_authorization_token.token.proxy_endpoint}" = {
#            auth = "${data.aws_ecr_authorization_token.token.authorization_token}"
#          }
#        }
#      })
#    }
#  
#    type = "kubernetes.io/dockerconfigjson"
#  }






#  locals {
#    kubeconfig = <<KUBECONFIG
#  
#  apiVersion: v1
#  clusters:
#  - cluster:
#      server: ${aws_eks_cluster.demo.endpoint}
#      certificate-authority-data: ${aws_eks_cluster.demo.certificate_authority.0.data}
#    name: kubernetes
#  contexts:
#  - context:
#      cluster: kubernetes
#      user: aws
#    name: aws
#  current-context: aws
#  kind: Config
#  preferences: {}
#  users:
#  - name: aws
#    user:
#      exec:
#        apiVersion: client.authentication.k8s.io/v1alpha1
#        command: aws-iam-authenticator
#        args:
#          - "token"
#          - "-i"
#          - "${var.cluster_name}"
#  KUBECONFIG
#  }
#  
#  output "kubeconfig" {
#    value = "${local.kubeconfig}"
#  }
#  
#  locals {
#  command = cat <<EOF | kubectl apply -f -
#  apiVersion: karpenter.sh/v1alpha5
#  kind: Provisioner
#  metadata:
#    name: default
#  spec:
#    requirements:
#      - key: karpenter.sh/capacity-type
#        operator: In
#        values: ["spot"]
#    limits:
#      resources:
#        cpu: 1000
#    provider:
#      subnetSelector:
#        karpenter.sh/discovery: ${var.cluster_name}
#      securityGroupSelector:
#        karpenter.sh/discovery: ${var.cluster_name}
#    ttlSecondsAfterEmpty: 30
#  EOF
#  }