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
}

# The sink cannot write anywhere until its (GCP-generated) writer identity is
# granted write access to the destination dataset.
resource "google_bigquery_dataset_iam_member" "writer" {
  dataset_id = var.dataset
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.default.writer_identity
}
