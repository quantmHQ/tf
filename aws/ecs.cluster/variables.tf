variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "environment" {
  # Simply a string for 'live', 'stage' or 'dev'
  description = "The environment of the resources"
}

variable "container_insights" {
  type    = string
  default = "enabled"
}
