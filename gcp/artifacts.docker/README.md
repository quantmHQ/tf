# GCP Artifact Registry Docker Module

## Description

This Terraform module provisions a Google Cloud Artifact Registry repository specifically configured for Docker images. It standardizes repository naming, location, and access control.

## Baseline Permissions

Our `permissions` module is the baseline for all modules and forms the basis of the Principle of Least Privilege (PoLP) to build secure modules. When assigning permissions to service accounts that interact with this repository (e.g., CI/CD pipelines), prefer using the fine-grained permission sets defined in the `permissions` module (e.g., `permissions.artifacts.docker.r`, `permissions.artifacts.docker.w`).

## Usage

```terraform
module "docker_repo" {
  source = "./modules/artifacts.docker"

  name        = "my-app"
  project     = "your-gcp-project-id"
  environment = "dev"
  location    = "us-central1"
  description = "Docker repository for My App"

  # Access Control
  service_account_r  = ["deployer@your-project.iam.gserviceaccount.com"]
  service_account_rw = ["ci-builder@your-project.iam.gserviceaccount.com"]
  
  # Public Access (Use with caution)
  public = false
}
```

## Inputs

| Name                 | Description                                                                                                  | Type           | Default | Required |
| :------------------- | :----------------------------------------------------------------------------------------------------------- | :------------- | :------ | :------: |
| `name`               | The base name for the artifact registry resources.                                                           | `string`       | -       |   yes    |
| `environment`        | The deployment environment (e.g., dev, staging, prod). Appended to the repository ID.                        | `string`       | -       |   yes    |
| `project`            | The GCP project ID for artifact registry.                                                                    | `string`       | -       |   yes    |
| `location`           | The GCP region where the artifact registry will be created.                                                  | `string`       | -       |   yes    |
| `description`        | Optional description for container registry.                                                                 | `string`       | `""`    |    no    |
| `service_account_r`  | A list of email addresses of service accounts that need read-only access (`roles/artifactregistry.reader`).  | `list(string)` | `[]`    |    no    |
| `service_account_rw` | A list of email addresses of service accounts that need read-write access (`roles/artifactregistry.writer`). | `list(string)` | `[]`    |    no    |
| `public`             | Whether the Artifact Registry repository should be publicly accessible.                                      | `bool`         | `false` |    no    |

## Outputs

| Name   | Description                                                                                                   |
| :----- | :------------------------------------------------------------------------------------------------------------ |
| `name` | The full name of the Artifact Registry repository.                                                            |
| `id`   | The short ID (name) of the Artifact Registry repository.                                                      |
| `url`  | The full URL of the Docker Artifact Registry repository. Use this for `docker login`, `push`, and `pull`.     |