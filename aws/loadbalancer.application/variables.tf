variable "lb_name" {
  description = "The name of the resource"
  type        = string
}

variable "environment" {
  description = "The environment of the resources"
  type        = string
}

variable "security_group" {
  description = "security group for load balancer"
}

variable "public_subnet_ids" {
  description = "list of public subnet ids"
  type        = list(string)
}

/* variable target_group_name {
  description = "The name of lb resources group"
  type        = string
}

variable target_port {
  description = "The port to use to connect with the target. Valid values are either ports 1-65535,"
  type        = number
  default     = 8000
}

variable target_type {
  description = "The type of target that you must specify when registering targets with this target group.The possible values are instance or ip or lambda."
  type        = string
  default     = "ip"
}

variable vpc {
  description = "The identifier of the VPC in which to create the target group. Required when target_type is instance or ip."
}

variable lb_certificate_arn {
  description = "The certificate arn"
  type        = string
}

variable ssl_policy {
  description = "ssl policy"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "lb_zone_id" {
  type = string
}

variable record_name {
  type = string
}

variable domain_name {
  type = string
}

variable zone_id {
  type = string
} */
