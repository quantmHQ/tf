# GCP BigQuery Dataset Terraform Module

## Description

This Terraform module creates and manages a Google BigQuery dataset. It provides:

*   **Naming Convention:** Uses the given name as the dataset ID.
*   **Retention:** Optional default table expiration, so tables (e.g. routed log tables) age out automatically.
*   **Protection:** Deletion protection enabled by default.
*   **Composable:** Pairs with `sink.bigquery`, which routes logs into the dataset.

## Baseline Permissions

Our `permissions` module is the baseline for all modules and forms the basis of the Principle of Least Privilege (PoLP) to build secure modules. This module attaches no service accounts of its own. Access is granted by consumers — e.g. `sink.bigquery` grants the sink's writer identity `roles/bigquery.dataEditor` on the dataset.

## Usage

```terraform
module "api_logs_dataset" {
  source   = "../bigquery.dataset"
  name     = "api_logs"
  project  = "your-gcp-project-id"
  location = "US"

  default_table_expiration_days = 30
}

module "api_logs" {
  source  = "../sink.bigquery"
  name    = "prod-api-logs"
  project = "your-gcp-project-id"
  dataset = module.api_logs_dataset.name

  resources = [
    { type = "cloud_run_revision", label = "service_name", name = module.api.name },
  ]
}
```

## Inputs

| Name                            | Description                                                                              | Type          | Default      | Required |
| :------------------------------ | :--------------------------------------------------------------------------------------- | :------------ | :----------- | :------: |
| `name`                          | The ID of the dataset.                                                                    | `string`      | -            |   yes    |
| `project`                       | The GCP Project ID where the dataset will be created.                                     | `string`      | -            |   yes    |
| `location`                      | The GCP location of the dataset (e.g. `US`, `EU`, `us-central1`).                         | `string`      | -            |   yes    |
| `description`                   | A description of the dataset.                                                             | `string`      | `A dataset`  |    no    |
| `labels`                        | Labels to apply to the dataset.                                                           | `map(string)` | `{}`         |    no    |
| `default_table_expiration_days` | Default days before tables in the dataset expire. `0` disables the default expiration.    | `number`      | `0`          |    no    |
| `delete_protection`             | Whether to protect the dataset from deletion.                                             | `bool`        | `true`       |    no    |

## Outputs

| Name        | Description                                  |
| :---------- | :------------------------------------------- |
| `id`        | The ID of the dataset.                        |
| `name`      | The ID of the dataset (same as `id`'s tail).  |
| `self_link` | The URI of the created resource.              |
| `location`  | The location of the dataset.                  |
