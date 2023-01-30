resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "docdb-${var.project}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = var.instance_class_size
}

resource "aws_docdb_cluster" "default" {
  cluster_identifier = "docdb-${var.project}"
  availability_zones = ["${var.region}a", "${var.region}b"]
  master_username    = var.master_username
  master_password    = var.master_password
}