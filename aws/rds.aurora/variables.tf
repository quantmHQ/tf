variable "region" {
  default     = "us-west-2"
  description = "The AWS region in which to create resources"
}

variable "environment" {
  # Simply a string for 'live', 'stage' or 'dev'
  description = "The environment of the resources"
}

variable "scope" {
  description = "The scope of resource"
}

variable "db_cluster_name" {
  description = "cluster identifier of RDS"
}

variable "sg_name" {
  description = "aws security group name"
}

variable "db_name" {
  description = "database name"
}

variable "db_user" {
  description = "database master user"
}

variable "db_pass" {
  description = "database password"
}

variable "scaling_min_capacity" {
  default = 2
}

variable "scaling_max_capacity" {
  default = 2
}

variable "scaling_auto_pause" {
  default = true
}

variable "scaling_auto_pause_time" {
  default = 3000
}

variable "security_group" {
  description = "security group of rds"
}

variable "private_subnet_ids" {
  description = "list of private subnet IDs"
}
