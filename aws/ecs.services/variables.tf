variable "environment" {
  # Simply a string for 'live', 'stage' or 'dev'
  description = "The environment of the resources"
}

variable "cluster_id" {
  description = "ecs cluster id"
  type        = string
}

variable "assign_public_ip" {
  description = "should we assign a public IP?"
  type        = bool
  default     = false
}

variable "tasks" {
  description = "container task defination"
}

variable "vpc" {
  description = "VPC"
}

/* variable "target_group__target_type" {
  description = "The type of target that you must specify when registering targets with this target group.The possible values are instance or ip or lambda."
  type        = string
  default     = "ip"
} */

variable "subnet_ids" {
  description = "list of private subnet id"
}

variable "security_group" {
  description = "security group"
}

variable "load_balancer" {
  description = "load balancer associated to the service"
  default     = null
}

variable "certificate_arn" {
  description = "The certificate arn"
  type        = string
}

variable "ssl_policy" {
  description = "ssl policy"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "zone_id" {
  description = "zone id"
}

variable "domain_name" {
  description = "domain name"
}

/* variable target_group_arn {
  description = "load balancer arn"
  type        = string
} */
