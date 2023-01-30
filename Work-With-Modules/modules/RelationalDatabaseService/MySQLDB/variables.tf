variable "allocated_size" {
  description = ""
  type = number
}

variable "database_name" {
  description = ""
  type = string
}

variable "instance_class_size" {
  description = ""
  type = string
  default = "db.t3.micro"
}

variable "username" {
  description = ""
  type = string
}

variable "password" {
  description = ""
  type = string
}