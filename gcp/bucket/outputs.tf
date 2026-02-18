output "name" {
  value       = google_storage_bucket.default.name
  description = "The name of the bucket"
}

output "id" {
  value       = google_storage_bucket.default.id
  description = "The ID of the bucket"
}

output "self_link" {
  value       = google_storage_bucket.default.self_link
  description = "The self-link of the bucket"
}

output "url" {
  value       = google_storage_bucket.default.url
  description = "The URL of the bucket"
}
