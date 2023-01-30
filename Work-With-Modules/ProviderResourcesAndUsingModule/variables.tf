
variable "account_id" {
  description = "Versão do build do docker"
  type        = string
}

variable "security_groups_id" {
  description = "Versão do build do docker"
  type        = string
}

variable "region" {
  description = "Versão do build do docker"
  type        = string
}

variable "name_aplication" {
  description = "Versão do build do docker"
  type        = string
}

variable "ambiente" {
  description = "Versão do build do docker"
  type        = string
}

variable "cluster_ecs_arn" {
  description = "Versão do build do docker"
  type        = string
}

variable "list_subnets" {
  type        = list(string)
  default     = []
  description = "List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)."
}

variable "project" {
  description = "Versão do build do docker"
  type        = string
}

variable "manager_project" {
  description = "Versão do build do docker"
  type        = string
}

variable "account_vpc_id" {
  description = "Versão do build do docker"
  type        = string
}

variable "path_health_check" {
  description = "Versão do build do docker"
  type        = string
}

variable "listener_https_arn" {
  description = "Versão do build do docker"
  type        = string
}

variable "header" {
  description = "Versão do build do docker"
  type        = string
}

variable "port" {
  type        = number
  description = "Port App."
}

variable "cpu" {
  type        = number
  description = "Port App."
}

variable "memory" {
  type        = number
  description = "Port App."
}