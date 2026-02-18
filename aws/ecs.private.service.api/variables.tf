variable "service_name" {
  description = "The name of the resource"
  type        = string
}

variable "environment" {
  # Simply a string for 'live', 'stage' or 'dev'
  description = "The environment of the resources"
}

variable "vpc" {
  description = "vpc object"
}

variable "cluster_id" {
  description = "ecs cluster id"
  type        = string
}

variable "assign_public_ip" {
  description = "public ip of service"
  type        = bool
  default     = false
}

variable "task" {
  description = "container task defination"
}

variable "security_group" {
  description = "security group of ecs"
}

variable "subnet_ids" {
  description = "list of private subnet id"
}
