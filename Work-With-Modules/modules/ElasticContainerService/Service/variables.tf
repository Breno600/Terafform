variable "name_aplication" {
  description = ""
  type = string
}

variable "cluster_ecs_arn" {
  description = ""
  type = string
}

variable "task_ecs_definition_arn" {
  description = ""
  type = string
}

variable "security_groups_id" {
  description = ""
  type = string
}

variable "list_subnets" {
  type        = list(string)
  default     = []
  description = "List."
}

variable "target_group_arn" {
  description = ""
  type = string
}

variable "port_task" {
  description = ""
  type = string
}

variable "project" {
  description = ""
  type = string
}

variable "manager_project" {
  description = ""
  type = string
}