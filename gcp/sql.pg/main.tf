# ------------------------------------------------------------------------------
# Random Password Generation
# ------------------------------------------------------------------------------

resource "random_password" "default" {
  length           = 32
  special          = true
  override_special = "!$&*()-_=+" # Use URL-safe characters for the password
}

# ------------------------------------------------------------------------------
# Cloud SQL Instance
# ------------------------------------------------------------------------------

resource "google_sql_database_instance" "default" {
  name             = var.name
  project          = var.project
  region           = var.region
  database_version = var.engine

  settings {
    edition           = "ENTERPRISE"
    tier              = var.tier
    availability_type = var.is_ha ? "REGIONAL" : "ZONAL"
    disk_autoresize   = true
    disk_size         = var.disk
    disk_type         = var.is_ha ? "PD_SSD" : "PD_HDD"

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.network
      enable_private_path_for_google_cloud_services = true
    }

    dynamic "backup_configuration" {
      for_each = var.is_ha ? [1] : []

      content {
        enabled                        = true
        point_in_time_recovery_enabled = true

        backup_retention_settings {
          retained_backups = 7 # Example: Retain 7 days of backups
          retention_unit   = "COUNT"
        }
      }
    }

    dynamic "database_flags" {
      for_each = var.database_flags

      content {
        name  = database_flags.key
        value = database_flags.value
      }
    }

    insights_config {
      query_insights_enabled  = var.enable_insights
      query_plans_per_minute  = 5
      record_application_tags = true
      record_client_address   = true
    }
  }

  deletion_protection = var.delete_protection
}

# ------------------------------------------------------------------------------
# Database within the Instance
# ------------------------------------------------------------------------------

resource "google_sql_database" "default" {
  name     = var.database_name
  project  = var.project
  instance = google_sql_database_instance.default.name

  depends_on = [
    google_sql_database_instance.default
  ]
}

# ------------------------------------------------------------------------------
# User within the Instance
# ------------------------------------------------------------------------------

resource "google_sql_user" "default" {
  name     = var.database_user
  project  = var.project
  instance = google_sql_database_instance.default.name
  password = random_password.default.result

  depends_on = [
    # Ensure the instance is ready before trying to create a user
    google_sql_database_instance.default,
    random_password.default,
  ]
}
