locals {
  annotations = merge(
    {
      "managed-by" = "terraform"
    },
    var.annotations,
  )

  image = "${var.image.url}/${var.image.name}:${var.image.tag}"
}

resource "google_cloud_run_v2_job" "default" {
  name        = var.name
  project     = var.project
  location    = var.region
  labels      = var.labels
  annotations = local.annotations

  template {
    template {
      service_account       = var.service_account
      execution_environment = "EXECUTION_ENVIRONMENT_GEN2"
      timeout               = var.timeout

      containers {
        name    = var.name
        image   = local.image
        command = length(var.command) > 0 ? var.command : null
        args    = length(var.args) > 0 ? var.args : null

        resources {
          limits = var.resources
        }

        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.key
            value = env.value
          }
        }

        dynamic "volume_mounts" {
          for_each = var.gcs_volumes

          content {
            name       = volume_mounts.key
            mount_path = volume_mounts.value.path
          }
        }
      }

      dynamic "volumes" {
        for_each = var.gcs_volumes

        content {
          name = volumes.key
          gcs {
            bucket    = volumes.value.bucket
            read_only = volumes.value.read_only
          }
        }
      }

      dynamic "vpc_access" {
        for_each = (var.network != null && var.subnet != null) ? [1] : []
        content {
          egress = "PRIVATE_RANGES_ONLY"
          network_interfaces {
            network    = var.network
            subnetwork = var.subnet
          }
        }
      }
    }
  }

  lifecycle {
    precondition {
      condition     = contains(module.valid.regions, var.region)
      error_message = "Region '${var.region}' is not allowed."
    }

    ignore_changes = [
      client,
      client_version,
      template.0.template.0.containers.0.image,
    ]
  }

  deletion_protection = var.delete_protection
}
