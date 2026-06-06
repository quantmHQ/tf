locals {
  annotations = merge(
    {
      "managed-by" = "terraform"
    },
    var.annotations,
  )

  image = "${var.image.url}/${var.image.name}:${var.image.tag}"
}

resource "google_cloud_run_v2_service" "default" {
  name     = var.name
  project  = var.project
  location = var.region

  template {
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"
    labels                = var.labels
    annotations           = local.annotations
    service_account       = var.service_account

    scaling {
      min_instance_count = var.min
      max_instance_count = var.max
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

    containers {
      name  = "default"
      image = local.image

      ports {
        container_port = var.port
      }

      startup_probe {
        initial_delay_seconds = 0
        timeout_seconds       = 10
        period_seconds        = 15
        failure_threshold     = 3

        http_get {
          path = var.healthz
        }
      }

      liveness_probe {
        initial_delay_seconds = 10
        period_seconds        = 30

        http_get {
          path = var.healthz
        }
      }

      dynamic "env" {
        for_each = var.env_vars

        content {
          name  = env.key
          value = env.value
        }
      }

      command = length(var.command) > 0 ? var.command : null
      args    = length(var.args) > 0 ? var.args : null

      resources {
        limits = {
          cpu              = var.resources.cpu
          memory           = var.resources.memory
          "nvidia.com/gpu" = var.resources.gpu != null ? var.resources.gpu : null
        }

        cpu_idle = var.has_request_based_pricing
      }

      dynamic "volume_mounts" {
        for_each = var.gcs_volumes
        content {
          name       = volume_mounts.key
          mount_path = volume_mounts.value.path
        }
      }
    }

    dynamic "containers" {
      for_each = var.sidecars

      content {
        name  = containers.key
        image = local.image

        dynamic "env" {
          for_each = merge(
            containers.value.inherit ? var.env_vars : {},
            coalesce(containers.value.env, {})
          )
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

        command = containers.value.command
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

  }

  lifecycle {
    ignore_changes = [
      client,
      client_version,
      template.0.containers.0.image,
      template.0.labels,
    ]
  }
}

resource "google_cloud_run_service_iam_binding" "default" {
  location = google_cloud_run_v2_service.default.location
  service  = google_cloud_run_v2_service.default.name
  project  = var.project
  role     = "roles/run.invoker"
  members  = var.invokers

  depends_on = [
    google_cloud_run_v2_service.default
  ]
}
