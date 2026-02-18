variable "project" {
  type        = string
  description = "Project ID"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "name" {
  type        = string
  description = "Name of the VPC"
}

variable "subnets" {
  type = map(object({
    cidr        = string
    region      = string
    description = optional(string)
    dual_stack  = optional(bool)
    secondary = optional(object({
      clusters = optional(map(object({
        svcs = string
        pods = string
      })))
    }))
  }))
  description = "subnets with CIDR block"

  validation {
    condition = alltrue([
      for k, subnet in var.subnets :
      length(k) > 0 && length(k) <= 63
    ])
    error_message = "subnet names must be between 1 and 63 characters long."
  }
}

variable "peering_ranges" {
  type        = list(string)
  default     = []
  description = "Range of IP addresses for the VPC peering"
}

variable "ingress_rules" {
  type = map(object({
    source_ranges = list(string)
    target_tags   = list(string)
    protocol      = string
    ports         = list(number)
  }))
  default     = {}
  description = "Ingress firewall rules to apply to target tags"
}
