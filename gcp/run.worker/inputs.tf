variable "name" {
  type        = string
  description = "The base name of the Cloud Run job (environment prefix will be added)."
}

variable "project" {
  type        = string
  description = "The GCP project ID for the Cloud Run job."
}

variable "environment" {
  type        = string
  description = "The environment (e.g., dev, prod) for the Cloud Run job. Used as a prefix for the job name."
}

variable "region" {
  type        = string
  description = "GCP Region for the Cloud Run job."
}

variable "service_account" {
  type        = string
  description = "The email address of the service account to use for the Cloud Run job."
}

variable "image" {
  type = object({
    url  = string
    name = string
    tag  = string
  })
  description = "A map defining the container image. Must contain keys 'url' (e.g., 'gcr.io/my-project' or 'us-central1-docker.pkg.dev/my-project/my-repo'), 'image' (e.g., 'my-app'), and 'tag' (e.g., 'v1.0.0' or 'latest')."

  validation {
    condition     = length(var.image.url) > 0 && length(var.image.name) > 0 && length(var.image.tag) > 0
    error_message = "Values for 'url', 'image', and 'tag' in the image map cannot be empty."
  }
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Environment variables to apply to the Cloud Run job container."
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the Cloud Run job."
}

variable "annotations" {
  type        = map(string)
  default     = {}
  description = "Annotations to apply to the Cloud Run job. Includes default Terraform annotation."
}

variable "network" {
  description = "The full self-link of the VPC network to connect the Cloud Run service."
  type        = string
  default     = null
}

variable "subnet" {
  description = "The full self-link of the subnetwork to connect the Cloud Run service."
  type        = string
  default     = null
}

variable "resources" {
  type = object({
    cpu    = string
    memory = string
    gpu    = optional(string)
  })

  default = {
    cpu    = "1"
    memory = "512Mi"
  }

  validation {
    condition     = length(var.resources.cpu) > 0 && length(var.resources.memory) > 0
    error_message = "Values for 'cpu' and 'memory' in the resources object cannot be empty."
  }
}

variable "gcs_volumes" {
  type = map(object({
    bucket    = string
    path      = string
    read_only = bool
  }))
  default     = {}
  description = "Map of GCS volumes to mount into the container. "
}

variable "command" {
  type        = list(string)
  default     = []
  description = "Command to execute in the container."
}

variable "args" {
  type        = list(string)
  default     = []
  description = "Arguments to pass to the command."
}

variable "sidecars" {
  description = "Map of sidecar containers to run alongside the main container. Keys are the sidecar names."
  type = map(object({
    inherit = bool
    command = optional(list(string))
    env     = optional(map(string))
    image = optional(object({
      url  = string
      name = string
      tag  = string
    }))
  }))
  default = {}
}

variable "otel_collector_config" {
  type        = string
  default     = ""
  description = "Otel collector configuration YAML as a rendered string."
}

variable "delete_protection" {
  type        = bool
  default     = true
  description = "Whether to protect the Cloud Run job from deletion."
}
