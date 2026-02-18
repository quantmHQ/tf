# Cloud Run Service Module

This Terraform module deploys a Google Cloud Run Service (v2). It simplifies the configuration of a containerized application, including networking, scaling, environment variables, sidecars, and volume mounts.

**Note:** The `permissions` module in this repository serves as the baseline for all modules, adhering to the principle of least privilege. Ensure that the service account used by this Cloud Run service has the necessary permissions defined in the `permissions` module (e.g., `permissions.run.svc.x` for runtime).

## Features

*   **Deploy Cloud Run Services:** Deploys a v2 Cloud Run service.
*   **Scaling:** Configurable min/max instances and request-based pricing (CPU allocation).
*   **Networking:** VPC Access via Direct VPC Egress (Private Ranges Only).
*   **Health Checks:** Configurable startup and liveness probes.
*   **Sidecars:** Support for sidecar containers with inheritance options.
*   **Volumes:** Support for mounting Google Cloud Storage (GCS) buckets as volumes.
*   **IAM:** Easy configuration of allowed invokers.

## Usage

```terraform
module "my_service" {
  source = "./modules/run.svc"

  name            = "my-app"
  environment     = "dev"
  project         = "my-gcp-project"
  region          = "us-central1"
  service_account = "my-service-account@my-gcp-project.iam.gserviceaccount.com"

  image = {
    url  = "us-central1-docker.pkg.dev/my-project/my-repo"
    name = "my-image"
    tag  = "v1.0.0"
  }

  env_vars = {
    DB_HOST = "10.0.0.5"
    DB_NAME = "users"
  }

  # Optional: VPC Connectivity
  network = "projects/my-project/global/networks/my-vpc"
  subnet  = "projects/my-project/regions/us-central1/subnetworks/my-subnet"

  # Optional: Scaling
  min = 1
  max = 10

  # Optional: GCS Volume
  gcs_volumes = {
    "config-volume" = {
      bucket    = "my-config-bucket"
      path      = "/etc/config"
      read_only = true
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Base name of the service (environment prefix will be added). | `string` | - | Yes |
| `environment` | Environment name (e.g., dev, prod). Used as prefix. | `string` | - | Yes |
| `project` | GCP Project ID. | `string` | - | Yes |
| `region` | GCP Region. | `string` | - | Yes |
| `service_account` | Email of the service account to run the service as. | `string` | - | Yes |
| `image` | Object defining the container image (`url`, `name`, `tag`). | `object` | - | Yes |
| `annotations` | Annotations to apply to the service. | `map(string)` | `{}` | No |
| `labels` | Labels to apply to the service. | `map(string)` | `{}` | No |
| `min` | Minimum number of instances. | `number` | `0` | No |
| `max` | Maximum number of instances. | `number` | `100` | No |
| `network` | Self-link of the VPC network. | `string` | `null` | No |
| `subnet` | Self-link of the subnetwork. | `string` | `null` | No |
| `port` | Container port to expose. | `number` | `8080` | No |
| `command` | Command to run in the container. | `list(string)` | `[]` | No |
| `args` | Arguments to pass to the container. | `list(string)` | `[]` | No |
| `resources` | Resource limits (`cpu`, `memory`, `gpu`). | `object` | `{ cpu = "1000m", memory = "512Mi" }` | No |
| `has_request_based_pricing` | Enable request-based pricing (CPU idles when no requests). | `bool` | `true` | No |
| `env_vars` | Environment variables for the container. | `map(string)` | `{}` | No |
| `healthz` | Path for health check endpoint. | `string` | `"/healthz"` | No |
| `gcs_volumes` | Map of GCS volumes to mount. | `map(object)` | `{}` | No |
| `invokers` | List of IAM members allowed to invoke the service. | `list(string)` | `["allUsers"]` | No |
| `delete_protection` | Enable deletion protection. | `bool` | `true` | No |
| `sidecars` | Configuration for sidecar containers. | `map(object)` | `{}` | No |

## Outputs

| Name | Description |
|------|-------------|
| `url` | The URL of the deployed Cloud Run service. |
| `id` | The fully qualified ID of the Cloud Run service. |
| `name` | The name of the deployed Cloud Run service. |