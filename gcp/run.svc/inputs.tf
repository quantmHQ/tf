variable "name" {
  description = "The base name of the Cloud Run service (environment prefix will be added)."
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod) for the Cloud Run service. Used as a prefix for the service name."
  type        = string
}

variable "region" {
  description = "GCP Region for the Cloud Run service."
  type        = string
}

variable "project" {
  description = "The GCP project ID for the Cloud Run service."
  type        = string
}

variable "annotations" {
  description = "Annotations to apply to the Cloud Run service. Includes default Terraform annotation."
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Labels to apply to the Cloud Run service."
  type        = map(string)
  default     = {}
}

variable "service_account" {
  description = "The email address of the service account to use for the Cloud Run service."
  type        = string
}

variable "min" {
  description = "Minimum number of instances to run."
  type        = number
  default     = 0
}

variable "max" {
  description = "Maximum number of instances to run."
  type        = number
  default     = 100
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

variable "image" {
  description = "A map defining the container image. Must contain keys 'url' (e.g., 'gcr.io/my-project' or 'us-central1-docker.pkg.dev/my-project/my-repo'), 'name' (e.g., 'my-app'), and 'tag' (e.g., 'v1.0.0' or 'latest')."
  type = object({
    url  = string
    name = string
    tag  = string
  })

  validation {
    condition     = length(var.image.url) > 0 && length(var.image.name) > 0 && length(var.image.tag) > 0
    error_message = "Values for 'url', 'name', and 'tag' in the image object cannot be empty."
  }
}

variable "port" {
  description = "Port to expose in the container."
  type        = number
  default     = 8080
}

variable "command" {
  description = "Command to run in the container."
  type        = list(string)
  default     = []
}

variable "args" {
  description = "Arguments to pass to the container."
  type        = list(string)
  default     = []
}

variable "resources" {
  description = "Resource allocation for the container."
  type = object({
    cpu    = string
    memory = string
    gpu    = optional(string)
  })
  default = {
    cpu    = "1000m"
    memory = "512Mi"
  }

  validation {
    condition     = length(var.resources.cpu) > 0 && length(var.resources.memory) > 0
    error_message = "Values for 'cpu' and 'memory' in the resources object cannot be empty."
  }
}

variable "has_request_based_pricing" {
  description = "Enables request-based pricing (CPU idles without requests). Set min instances > 0 for always-on CPU."
  type        = bool
  default     = true
}

variable "env_vars" {
  description = "Environment variables to apply to the Cloud Run service container."
  type        = map(string)
  default     = {}
}

variable "healthz" {
  description = "Path to the health check endpoint."
  type        = string
  default     = "/healthz"
}

variable "gcs_volumes" {
  description = "Map of GCS volumes to mount into the container. Keys are the volume names, values define 'bucket', 'path', and 'read_only'."
  type = map(object({
    bucket    = string
    path      = string
    read_only = bool
  }))
  default = {}
}

variable "invokers" {
  description = "List of invoker identities allowed to invoke the Cloud Run service. Use format like 'user:email@example.com', 'serviceAccount:sa@project.iam.gserviceaccount.com', 'group:group@example.com', or 'allUsers', 'allAuthenticatedUsers'."
  type        = list(string)
  default     = ["allUsers"]
}

variable "delete_protection" {
  description = "Enable deletion protection for the Cloud SQL instance. Set to false to allow deletion."
  type        = bool
  default     = true
}

variable "sidecars" {
  description = "Map of sidecar containers to run alongside the main container. Keys are the sidecar names."
  type = map(object({
    # If true, inherits image and environment variables from the main container.
    inherit = bool
    # Overrides the main container's command if specified. Required if inherit is false.
    command = optional(list(string))
    # Additional environment variables, merged with inherited env_vars if inherit is true.
    env = optional(map(string))
    # Optional specific image for the sidecar. Required if inherit is false.
    image = optional(object({
      url  = string
      name = string
      tag  = string
    }))
  }))
  default = {}
}
