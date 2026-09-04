variable "name" {
  type        = string
  description = "The name of the sink."
}

variable "project" {
  type        = string
  description = "The GCP project ID for the sink."
}

variable "dataset" {
  type        = string
  description = "The ID of the destination BigQuery dataset the sink routes logs into."
}

variable "service_account_r" {
  type        = list(string)
  default     = []
  description = "A list of email addresses of service accounts that need read-only access to the routed logs in the destination dataset."
}

variable "service_account_rw" {
  type        = list(string)
  default     = []
  description = "A list of email addresses of service accounts that need read-write access to the routed logs in the destination dataset."
}

variable "resources" {
  type = list(object({
    type  = string # resource.type, e.g. "cloud_run_revision"
    label = string # resource.labels.<label>, e.g. "service_name"
    name  = string # value to match, e.g. module.api.name
  }))
  default     = []
  description = "Resources whose logs should be routed by this sink. Must be the exact deployed names. Any match routes the entry."

  validation {
    condition     = length(var.resources) > 0 || length(var.labels) > 0
    error_message = "At least one of 'resources' or 'labels' must be set; an empty filter routes all project logs."
  }
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Log-entry labels to match (all pairs must match), e.g. { log_group = \"api\" }. Entries carrying all of these labels are routed, even if they match no entry in 'resources'."
}
