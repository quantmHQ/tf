# Cloud Run Job Terraform Module

This Terraform module deploys a **Cloud Run Job** on Google Cloud Platform (GCP). It simplifies the creation of batch jobs, allowing for configuration of compute resources, networking, and volume mounts.

> **Security Note:** This module relies on the `permissions` module to define the baseline of Least Privilege for the service account used by this job. Ensure your service account has the necessary permissions (e.g., `run.job.x`, `storage.r`, etc.) defined via the `permissions` module.

## Features

*   **Job Deployment:** Deploys a containerized job to Cloud Run (v2 API).
*   **Resource Configuration:** Customizable CPU and Memory limits.
*   **VPC Access:** Optional connection to a VPC network via Direct VPC Egress (Private Ranges Only).
*   **Volume Mounts:** Supports mounting GCS buckets as volumes.
*   **Environment Variables:** Easy injection of environment variables.
*   **Command & Args:** Override container entrypoint and arguments.
*   **Retries & Timeouts:** Configurable execution timeout and retry policies.

## Usage

```terraform
module "data_processing_job" {
  source = "./modules/run.job"

  name        = "data-processor"
  project     = "your-gcp-project-id"
  environment = "dev"
  region      = "us-central1"
  service_account = "service-account@your-project.iam.gserviceaccount.com"

  image = {
    url  = "us-central1-docker.pkg.dev/your-project/my-repo"
    name = "processor-image"
    tag  = "v1.2.3"
  }

  resources = {
    cpu    = "2000m"
    memory = "2Gi"
  }

  env_vars = {
    "LOG_LEVEL" = "info"
    "DB_HOST"   = "10.0.0.5"
  }

  # Optional: Connect to VPC
  # network = "projects/your-project/global/networks/my-vpc"
  # subnet  = "projects/your-project/regions/us-central1/subnetworks/my-subnet"

  timeout     = "3600s" # 1 hour
  max_retries = 3
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Base name of the job (prefixed with environment). | `string` | - | Yes |
| `project` | GCP Project ID. | `string` | - | Yes |
| `environment` | Environment name (e.g., `dev`, `prod`). | `string` | - | Yes |
| `region` | GCP Region. | `string` | - | Yes |
| `service_account` | Email of the service account to run the job. | `string` | - | Yes |
| `image` | Object defining the container image (`url`, `name`, `tag`). | `object` | - | Yes |
| `resources` | Compute limits (`cpu`, `memory`, optional `gpu`). | `object` | `cpu="1000m", memory="512Mi"` | No |
| `env_vars` | Map of environment variables. | `map(string)` | `{}` | No |
| `command` | Override container entrypoint. | `list(string)` | `[]` | No |
| `args` | Arguments passed to the command. | `list(string)` | `[]` | No |
| `network` | VPC Network self-link for private access. | `string` | `null` | No |
| `subnet` | VPC Subnet self-link for private access. | `string` | `null` | No |
| `gcs_volumes` | Map of GCS buckets to mount as volumes. Keys are volume names. Values contain `bucket`, `path`, `read_only`. | `map(object)` | `{}` | No |
| `timeout` | Max execution time (e.g., "600s"). | `string` | `"3600s"` | No |
| `max_retries` | Max retries per task. | `number` | `1` | No |
| `delete_protection` | Prevent accidental deletion. | `bool` | `true` | No |
| `labels` | Labels to apply to the job. | `map(string)` | `{}` | No |
| `annotations` | Annotations to apply to the job. | `map(string)` | `{}` | No |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The ID of the Cloud Run Job. |
| `name` | The full name of the Cloud Run Job. |