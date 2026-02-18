locals {
  annotations = merge(
    {
      "managed-by" = "terraform"
    },
    var.annotations,
  )

  image = "${var.image.url}/${var.image.name}:${var.image.tag}"
}

resource "google_secret_manager_secret" "otel_config" {
  count     = var.otel_collector_config != "" ? 1 : 0
  project   = var.project
  secret_id = "${var.name}-otel-config"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "otel_config" {
  count       = var.otel_collector_config != "" ? 1 : 0
  secret      = google_secret_manager_secret.otel_config[0].id
  secret_data = var.otel_collector_config
}

resource "google_secret_manager_secret_iam_member" "otel_config_access" {
  count     = var.otel_collector_config != "" ? 1 : 0
  project   = var.project
  secret_id = google_secret_manager_secret.otel_config[0].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.service_account}"
}


resource "google_cloud_run_v2_worker_pool" "main" {
  name        = var.name
  project     = var.project
  location    = var.region
  labels      = var.labels
  annotations = local.annotations

  launch_stage = "BETA"

  template {
    service_account = var.service_account

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

    /**
     * Sidecars
     */

    dynamic "containers" {
      for_each = var.sidecars

      content {
        name = containers.key
        image = (
          containers.value.image != null ?
          "${containers.value.image.url}/${containers.value.image.name}:${containers.value.image.tag}" :
          local.image
        )

        dynamic "env" {
          for_each = merge(containers.value.inherit ? var.env_vars : {}, coalesce(containers.value.env, {}))

          content {
            name  = env.key
            value = env.value
          }
        }

        command = containers.value.command
      }
    }

    dynamic "containers" {
      for_each = var.otel_collector_config != "" ? [1] : []

      content {
        name  = "otel-collector"
        image = "us-docker.pkg.dev/cloud-ops-agents-artifacts/google-cloud-opentelemetry-collector/otelcol-google:0.143.0"

        volume_mounts {
          name       = "otel-config"
          mount_path = "/etc/otelcol-google"
        }
      }
    }

    /**
     * Cloud Storage Volumes
     */

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

    /**
    * Otel Configuration Volume
    */

    dynamic "volumes" {
      for_each = var.otel_collector_config != "" ? [1] : []

      content {
        name = "otel-config"
        secret {
          secret = google_secret_manager_secret.otel_config[0].secret_id
          items {
            version = google_secret_manager_secret_version.otel_config[0].version
            path    = "config.yaml"
          }
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

  deletion_protection = var.delete_protection

  lifecycle {
    ignore_changes = [
      client,
      client_version,
      template.0.containers.0.image,
      template.0.labels,
    ]
  }
}
