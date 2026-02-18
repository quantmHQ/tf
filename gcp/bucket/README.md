# GCP Cloud Storage Bucket Terraform Module

## Description

This Terraform module creates and manages a Google Cloud Storage (GCS) bucket. It provides a standardized way to provision buckets with best practices, including:

*   **Naming Convention:** Automatically prefixes the bucket name with the environment (e.g., `dev-my-bucket`).
*   **Security:** Enforces Uniform Bucket Level Access.
*   **Versioning:** Enables object versioning by default.
*   **Access Control:** Simplifies IAM bindings for read-only and read-write service accounts.
*   **CORS:** Optional support for Cross-Origin Resource Sharing (CORS) configuration.
*   **Public Access:** Optional flag to make the bucket publicly readable (use with caution).

## Baseline Permissions

Our `permissions` module is the baseline for all modules and forms the basis of the Principle of Least Privilege (PoLP) to build secure modules. When assigning permissions to service accounts that interact with this bucket, prefer using the fine-grained permission sets defined in the `permissions` module over broad predefined roles.

## Usage

```terraform
module "my_bucket" {
  source = "./modules/bucket"

  name        = "assets"
  project     = "your-gcp-project-id"
  environment = "dev"
  location    = "US"
  description = "Bucket for static assets"

  # Access Control
  service_account_r  = ["service-account-viewer@your-project.iam.gserviceaccount.com"]
  service_account_rw = ["service-account-uploader@your-project.iam.gserviceaccount.com"]

  # Optional Features
  enable_cors   = true
  force_destroy = false
}
```

## Inputs

| Name                 | Description                                                                                                  | Type           | Default   | Required |
| :------------------- | :----------------------------------------------------------------------------------------------------------- | :------------- | :-------- | :------: |
| `name`               | The base name of the bucket. The environment will be prefixed to this name (e.g., `env-name`).               | `string`       | -         |   yes    |
| `project`            | The GCP Project ID where the bucket will be created.                                                         | `string`       | -         |   yes    |
| `environment`        | The environment name (e.g., `dev`, `prod`). Used as a prefix for the bucket name.                            | `string`       | `dev`     |    no    |
| `location`           | The GCP location for the bucket (e.g., `US`, `us-central1`). Can be multi-region or regional.                | `string`       | -         |   yes    |
| `description`        | A description of the bucket.                                                                                 | `string`       | `A bucket`|    no    |
| `service_account_r`  | A list of service account emails that require read-only access (`roles/storage.objectViewer`).               | `list(string)` | `[]`      |    no    |
| `service_account_rw` | A list of service account emails that require read-write access (`roles/storage.objectAdmin`).               | `list(string)` | `[]`      |    no    |
| `public`             | If set to `true`, the bucket content will be publicly readable (`allUsers` get `objectViewer`).              | `bool`         | `false`   |    no    |
| `enable_cors`        | If `true`, enables CORS allowing `*` origin, methods, and headers.                                           | `bool`         | `false`   |    no    |
| `force_destroy`      | If `true`, allows the bucket to be destroyed even if it contains objects.                                    | `bool`         | `false`   |    no    |

## Outputs

| Name        | Description                                  |
| :---------- | :------------------------------------------- |
| `name`      | The full name of the created bucket.         |
| `id`        | The ID of the bucket.                        |
| `self_link` | The URI of the created resource.             |
| `url`       | The base URL of the bucket, in the format `gs://<bucket-name>`. |