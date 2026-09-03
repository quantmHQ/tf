variable "name" {
  type        = string
  description = "The ID of the BigQuery dataset."
}

variable "project" {
  type        = string
  description = "The GCP project ID for the dataset."
}

variable "location" {
  type        = string
  description = "The GCP location of the dataset (e.g. US, EU, us-central1)."
}

variable "description" {
  type        = string
  description = "A description of the dataset."
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the dataset."
}

variable "default_table_expiration_days" {
  type        = number
  default     = 0
  description = "Default number of days before tables in the dataset expire. 0 disables the default expiration."
}

variable "delete_protection" {
  type        = bool
  default     = true
  description = "Whether to protect the dataset from deletion."
}
