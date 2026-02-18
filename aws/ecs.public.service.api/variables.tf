variable "service_name" {
  description = "The name of the resource"
  type        = string
}

variable "environment" {
  # Simply a string for 'live', 'stage' or 'dev'
  description = "The environment of the resources"
}

variable "cluster_id" {
  description = "ecs cluster id"
  type        = string
}

variable "assign_public_ip" {
  description = "public ip of service"
  type        = bool
}

variable "task" {
  description = "container task defination"
}

variable "subnet_ids" {
  description = "list of private subnet id"
}

variable "security_group" {
  description = "security group for traffic rules"
}

variable "container_name" {
  description = "container name of service"
  type        = string
}

variable "container_port" {
  description = "container port"
  type        = number
}

variable "target_group_arn" {
  description = "load balancer arn"
  type        = string
}
