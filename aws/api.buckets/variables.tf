variable "region" {
  default     = "us-west-2"
  description = "The AWS region in which to create resources"
}

variable "environment" {
  # Simply a string for 'live', 'stage' or 'dev'
  description = "The environment of the resources"
}

variable "scope" {
  description = "The scope of the resources, either the environment name, or the developer name"
}
