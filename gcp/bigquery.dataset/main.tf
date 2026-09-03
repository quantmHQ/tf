resource "google_bigquery_dataset" "default" {
  dataset_id                  = var.name
  project                     = var.project
  location                    = var.location
  description                 = var.description
  labels                      = var.labels
  default_table_expiration_ms = var.default_table_expiration_days > 0 ? var.default_table_expiration_days * 86400000 : null
}
