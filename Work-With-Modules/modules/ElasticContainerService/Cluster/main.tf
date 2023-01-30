resource "aws_ecs_cluster" "ecs_cluster" {
  name = "clt-${var.project}"

  tags = {
    Project = "${var.project}"
    Terraform = "true"
  }
}

output "cluster_arn" {
  description = "The ARN of the created ECS cluster."
  value       = aws_ecs_cluster.ecs_cluster.arn
}