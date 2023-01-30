resource "aws_ecs_service" "ecsservice" {
  #depends_on = [aws_ecs_task_definition.ecsservicetask]
  name            = "service-${var.name_aplication}"
  cluster         = "${var.cluster_ecs_arn}"
  task_definition = "${var.task_ecs_definition_arn}"
  launch_type       = "FARGATE"
  platform_version  = "LATEST"
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 0
  desired_count = 1

  network_configuration {
    subnets = var.list_subnets
    security_groups = [var.security_groups_id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.name_aplication}"
    container_port   = var.port_task
  }
  
  tags = {
    Project = "${var.project}"
    Terraform = "true"
    Request   = "${var.manager_project}"  
  }
}