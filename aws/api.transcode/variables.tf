variable "region" {
  default     = "us-west-2"
  description = "The AWS region in which to create resources"
}

variable "environment" {
  # Simply a string for 'live', 'stage' or 'dev'
  #  In future, we will have a map of resources and rename this to tags
  description = "The environment of the resources"
}

variable "scope" {
  description = "The scope of the resources, either the environment name, or the developer name."
}

variable "role" {
  description = "The role that works accross the transcode process"
}

variable "video_in_bucket" {
  description = "S3 bucket to watch for videos"
}

variable "video_out_bucket" {
  description = "S3 bucket to put encoded videos"
}
