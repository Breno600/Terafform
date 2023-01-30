
variable "name_aplication" {
  description = "Versão do build do docker"
  type        = string
}

variable "project" {
  description = "Região da aws"
  type        = string
}

variable "manager_project" {
  type        = string
  description = "VPC ID."
}