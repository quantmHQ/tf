output "id" {
  description = "The ID of the sink."
  value       = google_logging_project_sink.default.id
}

output "name" {
  description = "The name of the sink."
  value       = google_logging_project_sink.default.name
}

output "filter" {
  description = "The rendered Logging query the sink routes on. Resource names cannot be validated by the module; a wrong name silently routes nothing."
  value       = local.filter
}

output "writer_identity" {
  description = "The Google-managed service account the sink writes as (granted dataEditor on the destination dataset)."
  value       = google_logging_project_sink.default.writer_identity
}
