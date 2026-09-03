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
  destination            = "storage.googleapis.com/${var.bucket}"
  filter                 = local.filter
  unique_writer_identity = true
}

# The sink cannot write anywhere until its (GCP-generated) writer identity is
# granted write access to the destination bucket.
resource "google_storage_bucket_iam_member" "writer" {
  bucket = var.bucket
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.default.writer_identity
}
