resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/ecs/${var.name_aplication}-${var.ambiente}"
  retention_in_days = 7
  tags = {
    Project = "${var.project}"
    Environment = "${var.ambiente}"
    Terraform = "true"
    Request   = "${var.manager_project}"  
  }
}