output "name" {
  description = "The full name of the Artifact Registry repository (projects/.../locations/.../repositories/...). Useful for IAM policies."
  value       = google_artifact_registry_repository.default.name
}

output "id" {
  description = "The short ID (name) of the Artifact Registry repository."
  value       = google_artifact_registry_repository.default.repository_id
}

output "url" {
  description = "The full URL of the Docker Artifact Registry repository. Use this for docker login/push/pull."
  value       = "${google_artifact_registry_repository.default.location}-docker.pkg.dev/${google_artifact_registry_repository.default.project}/${google_artifact_registry_repository.default.repository_id}"
}
