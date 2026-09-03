# GCP Log Sink (BigQuery) Terraform Module

## Description

This Terraform module creates a Cloud Logging sink that routes logs of a selected group of resources into a BigQuery dataset. It provides:

*   **Selective routing:** Builds the sink filter from an explicit `resources` list. Each entry names a `resource.type` (e.g. `cloud_run_revision`), a resource label (e.g. `service_name`), and the exact deployed name to match. Entries are OR-ed together.
*   **Label-based grouping:** Alternatively (or additionally), routes any log entry carrying a set of `labels` (e.g. `log_group = "api"`). Tag services with the label and they join the sink without being enumerated. Label pairs are AND-ed together.
*   **Composable:** The destination dataset is an input, not a concern of this module.

## Baseline Permissions

Our `permissions` module is the baseline for all modules and forms the basis of the Principle of Least Privilege (PoLP) to build secure modules. This module attaches no service accounts of its own. It makes exactly one IAM grant on the destination dataset:

*   `roles/bigquery.dataEditor` for the sink's Google-managed writer identity — without it GCP creates the sink broken.

## Usage

```terraform
module "api_logs" {
  source  = "../sink.bigquery"
  name    = "prod-api-logs"
  project = "your-gcp-project-id"
  dataset = "api_logs"

  resources = [
    { type = "cloud_run_revision", label = "service_name", name = module.api.name },
    { type = "cloud_run_job",      label = "job_name",      name = module.worker.name },
  ]

  # Or, instead of enumerating resources, tag the run modules with
  # labels = { log_group = "api" } and match the tag here:
  # labels = { log_group = "api" }
}
```

The filter rendered by the usage above:

```
(resource.type="cloud_run_revision" AND resource.labels.service_name="prod-api")
OR
(resource.type="cloud_run_job" AND resource.labels.job_name="prod-worker")
```

## Notes

*   The dataset must already exist; the sink creates its tables inside it (one dated table per day, `logging_<sink-name>_YYYYMMDD`).
*   `resources[].name` must be the exact deployed name, environment prefix included — the outputs of the `run.*` modules (`module.api.name`) already are.
*   Sinks only route new log entries; nothing is backfilled.
*   At least one of `resources` or `labels` must be set. An empty filter is valid GCP syntax and would route every log entry in the project.

## Inputs

| Name        | Description                                                                                                                                    | Type                                                                            | Default | Required |
| :---------- | :--------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------ | :------ | :------: |
| `name`      | The name of the sink.                                                                                                                           | `string`                                                                        | -       |   yes    |
| `project`   | The GCP Project ID where the sink will be created.                                                                                              | `string`                                                                        | -       |   yes    |
| `dataset`   | The ID of the destination BigQuery dataset the sink routes logs into.                                                                           | `string`                                                                        | -       |   yes    |
| `resources` | Resources to route logs from. `type` is the log `resource.type`, `label` is a `resource.labels.*` key, `name` is the exact deployed name. OR-ed. | `list(object({ type = string, label = string, name = string }))`                 | `[]`    |    no    |
| `labels`    | Log-entry labels to match; all pairs must match (AND-ed). OR-ed with `resources`.                                                               | `map(string)`                                                                   | `{}`    |    no    |

## Outputs

| Name              | Description                                                        |
| :---------------- | :----------------------------------------------------------------- |
| `id`              | The ID of the sink.                                                 |
| `name`            | The name of the sink.                                               |
| `filter`          | The rendered Logging query the sink routes on.                      |
| `writer_identity` | The Google-managed service account the sink writes as.              |
