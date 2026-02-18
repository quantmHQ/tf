variable "name" {
  description = "The name of the Cloud SQL PostgreSQL instance."
  type        = string
}

variable "project" {
  description = "The ID of the Google Cloud project where the instance will be created."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'stg', 'prd'). Used for naming/labeling."
  type        = string
}

variable "region" {
  description = "The GCP region for the Cloud SQL instance."
  type        = string
}

variable "network" {
  description = "The self-link or name of the VPC network for private IP connectivity. VPC Peering will be enabled automatically by the module."
  type        = string
}

variable "engine" {
  description = "The database engine type and version (e.g., 'POSTGRES_15')."
  type        = string
  default     = "POSTGRES_16"
}

variable "tier" {
  description = "The machine type tier for the Cloud SQL instance (e.g., 'db-f1-micro', 'db-custom-2-7680')."
  default     = "db-f1-micro"
  type        = string
}

variable "disk" {
  description = "The size of the data disk in GB."
  default     = 10
  type        = number
}

variable "is_ha" {
  description = "Enable High Availability. If true, creates a Regional instance with SSD disk and enables backups. If false, creates a Zonal instance."
  type        = bool
  default     = false
}

variable "enable_insights" {
  description = "Enable Cloud SQL Insights for query monitoring and diagnostics."
  type        = bool
  default     = false
}

variable "database_flags" {
  description = "A map of database flags to apply to the instance (e.g., { 'log_connections' = 'on' })."
  type        = map(string)
  default     = {}
}

variable "delete_protection" {
  description = "Enable deletion protection for the Cloud SQL instance."
  type        = bool
  default     = true # Recommended for production environments
}


variable "database_name" {
  description = "The name of the database to create."
  type        = string
}

variable "database_user" {
  description = "The username for the database user."
  type        = string
}
