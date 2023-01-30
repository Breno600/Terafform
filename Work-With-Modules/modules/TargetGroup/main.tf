resource "aws_lb_target_group" "ecs_target" {
  name     = "tg-${var.name_aplication}-${var.ambiente}"
  port     = var.port
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = var.account_vpc_id

  health_check {
    path = "/${var.path_health_check}"
    matcher  = "200,301"
    protocol = "HTTP"
  }

  tags = {
    Project = "${var.project}"
    Terraform = "true"
    Request   = "${var.manager_project}"  
  }
}

output "tg_arn" {
  description = "The ARN of the created tg."
  value       = aws_lb_target_group.ecs_target.arn
}