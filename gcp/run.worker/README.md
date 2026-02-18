# Cloud Run Worker Module

This Terraform module deploys a **Cloud Run Worker** on Google Cloud Platform (GCP). It is designed for background processing tasks and includes advanced features for observability and sidecar management.

## Features

*   **Worker Deployment:** Provisions a Cloud Run worker resource.
*   **OpenTelemetry Support:** Built-in support for deploying the Google Cloud OpenTelemetry collector as a sidecar, with configuration managed via Secret Manager.
*   **Sidecars:** Flexible configuration for additional sidecar containers (e.g., proxies, log shippers).
*   **VPC Connectivity:** Supports Direct VPC Egress for secure access to private resources (Redis, DBs, etc.).
*   **Volume Mounts:** Easy mounting of GCS buckets as volumes.
*   **Secret Management:** Automatically handles Secret Manager resources for Otel configuration.

## Baseline Permissions

Our `permissions` module is the baseline for all modules and forms the basis of the Principle of Least Privilege (PoLP) to build secure modules. Ensure the service account used by this worker has the appropriate permissions (e.g., `run.job.x`, `secretmanager.secretAccessor`) defined via the `permissions` module.

## Usage

```terraform
module "worker" {
  source = "./modules/run.worker"

  name            = "image-processor"
  project         = "your-gcp-project-id"
  environment     = "prod"
  region          = "us-central1"
  service_account = "worker-sa@your-project.iam.gserviceaccount.com"

  image = {
    url  = "us-central1-docker.pkg.dev/your-project/app-repo"
    name = "processor"
    tag  = "v1.0.0"
  }

  resources = {
    cpu    = "2"
    memory = "4Gi"
  }

  # Optional: OpenTelemetry Collector
  otel_collector_config = file("${path.module}/otel-config.yaml")

  # Optional: VPC Connection
  network = "projects/your-project/global/networks/vpc-main"
  subnet  = "projects/your-project/regions/us-central1/subnetworks/private-subnet"

  env_vars = {
    QUEUE_URL = "https://..."
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Base name of the worker. | `string` | - | Yes |
| `project` | GCP Project ID. | `string` | - | Yes |
| `environment` | Environment name (e.g., `dev`, `prod`). | `string` | - | Yes |
| `region` | GCP Region. | `string` | - | Yes |
| `service_account` | Email of the service account. | `string` | - | Yes |
| `image` | Object defining the container image (`url`, `name`, `tag`). | `object` | - | Yes |
| `resources` | Compute limits (`cpu`, `memory`, optional `gpu`). | `object` | `cpu="1", memory="512Mi"` | No |
| `env_vars` | Map of environment variables. | `map(string)` | `{}` | No |
| `command` | Override container entrypoint. | `list(string)` | `[]` | No |
| `args` | Arguments passed to the command. | `list(string)` | `[]` | No |
| `network` | VPC Network self-link. | `string` | `null` | No |
| `subnet` | VPC Subnet self-link. | `string` | `null` | No |
| `gcs_volumes` | Map of GCS buckets to mount. | `map(object)` | `{}` | No |
| `sidecars` | Map of sidecar containers configuration. | `map(object)` | `{}` | No |
| `otel_collector_config` | YAML string for Otel collector config. If set, deploys Otel sidecar. | `string` | `""` | No |
| `delete_protection` | Prevent accidental deletion. | `bool` | `true` | No |
| `labels` | Labels to apply. | `map(string)` | `{}` | No |
| `annotations` | Annotations to apply. | `map(string)` | `{}` | No |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the worker pool resource. |
| `name` | The name of the worker pool resource. |