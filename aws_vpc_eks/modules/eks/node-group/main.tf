resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = var.name-eks-cluster #aws_eks_cluster.devopsthehardway-eks.name
  node_group_name = var.name-worker-node-group #"devopsthehardway-workernodes"
  node_role_arn  = var.role-workernode-arn #baws_iam_role.workernodes.arn
  subnet_ids   = [var.subnet-private-eks-01, var.subnet-private-eks-02]
  instance_types = ["t3.xlarge"]
 
  scaling_config {
   desired_size = 1
   max_size   = 3
   min_size   = 1
  }
}