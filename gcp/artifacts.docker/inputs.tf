variable "name" {
  description = "The name for the artifact registry resources"
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "The GCP project ID for artifact registry"
  type        = string
}

variable "description" {
  description = "Optional description for container registry"
  default     = ""
}

variable "location" {
  description = "The GCP region where the artifact registry will be created"
  type        = string
}

variable "service_account_r" {
  description = "A list of email addresses of service accounts that need read-only access to the Artifact Registry"
  type        = list(string)
  default     = []
}

variable "service_account_rw" {
  description = "A list of email addresses of service accounts that need read-write access to the Artifact Registry"
  type        = list(string)
  default     = []
}

variable "public" {
  description = "Whether the Artifact Registry repository should be publicly accessible"
  type        = bool
  default     = false
}
