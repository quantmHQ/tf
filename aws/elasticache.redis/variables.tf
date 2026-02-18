variable "environment" {
  # Simply a string for 'live', 'stage' or 'dev'
  description = "The environment of the resources"
  type        = string
}

variable "redis_cluster_name" {
  description = "cluster identifier of redis"
  type        = string
}

variable "engine_version" {
  description = "Version number of the cache engine to be used"
  type        = string
  default     = "5.0.6"
}

variable "node_type" {
  description = "The compute and memory capacity of the nodes"
  type        = string
  default     = "cache.t2.micro"
}

variable "cache_nodes" {
  description = "The initial number of cache nodes that the cache cluster will have. For Redis, this value must be 1. "
  type        = number
  default     = 1
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "sg_name" {
  description = "subnet group name"
}

variable "port" {
  description = "The port number on which each of the cache nodes will accept connections. For Redis the default port is 6379."
  type        = number
  default     = 6379
}

variable "security_group" {
  description = "security group of redis"
}
