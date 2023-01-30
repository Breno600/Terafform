locals {
  app_image = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.name_aplication}-${var.ambiente}:#{BUILD_ID}#"
}

module "ecs-service" {
  source                  = "./modules/ElasticContainerService/Service"

  name_aplication         = var.name_aplication
  cluster_ecs_arn         = var.cluster_ecs_arn
  task_ecs_definition_arn = aws_ecs_task_definition.ecsservicetask.arn
  list_subnets            = var.list_subnets
  security_groups_id      = var.security_groups_id
  target_group_arn        = module.tg-app.tg_arn
  port_task               = var.port
  project                 = var.project
  manager_project         = var.manager_project

  depends_on=["aws_ecs_task_definition.ecsservicetask","module.tg-app"]
}

module "tg-app" {
  source            = "./modules/TargetGroup"

  name_aplication	  = var.name_aplication
  ambiente          = var.ambiente
  port              = var.port
  account_vpc_id    = var.account_vpc_id
  path_health_check = var.path_health_check
  project           = var.project
  manager_project   = var.manager_project
}

module "log-group" {
  source            = "./modules/CloudWatch/LogGroup"

  name_aplication	  = var.name_aplication
  ambiente          = var.ambiente
  project           = var.project
  manager_project   = var.manager_project
}

module "alb-rule-header" {
  source              = "./modules/LoadBalancer/AplicationLoadBalancer/Rules/rules-header"
  depends_on=["module.tg-app"]
  listener_https_arn  = var.listener_https_arn
  target_group_arn    = module.tg-app.tg_arn
  header              = var.header
  ambiente            = var.ambiente
}

module "iam-role" {
  source              = "./modules/IdentityAccessManagement/Role/Ecs"
  name_aplication     = var.name_aplication
  project             = var.project
  manager_project     = var.manager_project
}

module "iam-policy" {
  source              = "./modules/IdentityAccessManagement/Policy/Ecs"
  name_aplication     = var.name_aplication
}

module "iam-attach-policy-to-role" {
  source              = "./modules/IdentityAccessManagement/AttachPolicyToRole"
  role_name           = var.name_aplication
  policy_arn          = module.iam-policy.policy_arn
  depends_on=["module.iam-policy", "module.iam-role"]
}

resource "aws_ecs_task_definition" "ecsservicetask" {
  depends_on=["module.iam-role","module.log-group"]
  family                   = "task-${var.name_aplication}"
  requires_compatibilities      = ["FARGATE", "EC2"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = module.iam-role.role_arn
  task_role_arn            = module.iam-role.role_arn
  container_definitions    = <<TASK_DEFINITION
[
        {
            "name": "${var.name_aplication}",
            "image": "${local.app_image}",
            "essential": true,
            "cpu": 0,
            "memory": ${var.memory},
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/${var.name_aplication}-${var.ambiente}",
                    "awslogs-region": "${var.region}",
                    "awslogs-stream-prefix": "ecs"
                }
            },
            "portMappings": [
                {
                    "containerPort": ${var.port},
                    "protocol": "tcp"
                }
            ],
            "environment": [
              {
                "name": "TZ",
                "value":"America/Sao_Paulo"
              }
            ]
        }
    ]
TASK_DEFINITION
  tags = {
    Project = "${var.project}"
    Terraform = "true"
    Request   = "${var.manager_project}"  
  }

  runtime_platform {
    operating_system_family = "LINUX"
  }
}