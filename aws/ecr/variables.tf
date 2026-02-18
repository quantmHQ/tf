variable "name" {
  description = "The name of the resource"
  type        = string
}

variable "environment" {
  # Simply a string for 'live', 'stage' or 'dev'
  description = "The environment of the resources"
}
