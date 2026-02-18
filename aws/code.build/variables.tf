variable "build_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "description" {
  type = string
}

variable "cache_mode" {
  type    = list(string)
  default = []
}

variable "cache_type" {
  type    = string
  default = "NO_CACHE"
}

variable "build_timeout" {
  default = "60"
}

variable "build_compute_type" {
  type    = string
  default = "BUILD_GENERAL1_SMALL"
}

variable "build_image" {
  type = string
}

variable "privileged_mode" {
  type = bool
}

variable "role" {
  type = string
}

variable "artifact_type" {
  type    = string
  default = "CODEPIPELINE"
}

variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  default = [{
    name  = "NO_ADDITIONAL_BUILD_VARS"
    value = "TRUE"
  }]
}

variable "buildspec" {
  description = "buildspec file name"
  type        = string
}

variable "source_type" {
  type    = string
  default = "CODEPIPELINE"
}

variable "logs_name" {
  type    = string
  default = ""
}
