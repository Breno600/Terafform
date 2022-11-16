resource "aws_eks_cluster" "cluster-eks" {
 name = var.cluster-name
 role_arn = var.eks-iam-role-arn  #aws_iam_role.eks-iam-role.arn
 enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
 

 vpc_config {
  subnet_ids = [var.subnet-private-eks-01, var.subnet-private-eks-02]
 }

}