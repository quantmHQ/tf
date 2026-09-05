locals {
  resource_clauses = [
    for r in var.resources :
    "(resource.type=\"${r.type}\" AND resource.labels.${r.label}=\"${r.name}\")"
  ]

  # All label pairs must match on the entry: labels."log_group"="api" AND ...
  label_clauses = length(var.labels) > 0 ? [
    "( ${join(" AND ", [for k, v in var.labels : "labels.\"${k}\"=\"${v}\""])} )"
  ] : []

  filter = join("\nOR ", concat(local.resource_clauses, local.label_clauses))
}

resource "google_logging_project_sink" "default" {
  name                   = var.name
  project                = var.project
  destination            = "bigquery.googleapis.com/projects/${var.project}/datasets/${var.dataset}"
  filter                 = local.filter
  unique_writer_identity = true

  bigquery_options {
    use_partitioned_tables = true
  }
}

# The sink cannot write anywhere until its (GCP-generated) writer identity is
# granted write access to the destination dataset.
resource "google_bigquery_dataset_iam_binding" "writers" {
  dataset_id = var.dataset
  role       = "roles/bigquery.dataEditor"
  project = var.project

  members = concat(
    [google_logging_project_sink.default.writer_identity],
    [for email in var.service_account_rw : "serviceAccount:${email}"]
  )
}

# --- IAM Binding for Read-Only Service Accounts ---
resource "google_bigquery_dataset_iam_binding" "readers" {
  count = length(var.service_account_r) > 0 ? 1 : 0

  dataset_id = var.dataset
  role       = "roles/bigquery.dataViewer"
  project    = var.project

  members = [
    for email in var.service_account_r : "serviceAccount:${email}"
  ]
}
