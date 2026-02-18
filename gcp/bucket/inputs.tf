variable "name" {
  type        = string
  description = "Name of the GCP bucket"
}

variable "description" {
  type        = string
  description = "Description of the GCP bucket"
  default     = "A bucket"
}

variable "environment" {
  type        = string
  description = "Environment of the GCP bucket"
  default     = "dev"
}


variable "project" {
  type        = string
  description = "GCP Project ID"
}

variable "location" {
  type        = string
  description = "GCP location, can be multi-region or regional"
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
  type        = bool
  description = "Whether the bucket should be public"
  default     = false
}

variable "enable_cors" {
  type = bool
  description = "Enable CORS for the bucket"
  default = false
}

variable "force_destroy" {
  type = bool
  description = "Force destroy the bucket"
  default = false
}
