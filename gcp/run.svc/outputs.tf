output "url" {
  description = "The URL of the deployed Cloud Run service."
  value       = google_cloud_run_v2_service.default.uri
}

output "id" {
  description = "The fully qualified ID of the Cloud Run service."
  value       = google_cloud_run_v2_service.default.id
}

output "name" {
  description = "The name of the deployed Cloud Run service (including environment prefix)."
  value       = google_cloud_run_v2_service.default.name
}
