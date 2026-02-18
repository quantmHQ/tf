output "artifacts" {
  description = "Artifact Registry permissions structure (repo, docker, maven, npm, python)."
  value       = local.artifacts
}

output "kms" {
  description = "Cloud KMS permissions structure."
  value       = local.kms
}

output "run" {
  description = "Cloud Run permissions structure (svc, job)."
  value       = local.run
}

output "k8s" {
  description = "GKE permissions structure."
  value       = local.k8s
}

output "iam" {
  description = "IAM Service Account permissions structure."
  value       = local.iam
}

output "resourcemanager" {
  description = "Resource Manager Project permissions structure."
  value       = local.resourcemanager
}

output "sql" {
  description = "Cloud SQL permissions structure."
  value       = local.sql
}

output "observe" {
  description = "Observability (Logging, Monitoring, Trace) permissions structure."
  value       = local.observe
}

output "storage" {
  description = "Cloud Storage permissions structure."
  value       = local.storage
}

output "pubsub" {
  description = "PubSub"
  value       = local.pubsub
}

output "eventarc" {
  description = "Eventarc"
  value       = local.eventarc
}

output "firebase" {
  description = "Firebase permissions structure (auth, hosting)."
  value       = local.firebase
}

output "serviceusage" {
  description = "Service Usage permissions structure (for enabling services and managing API keys)."
  value       = local.serviceusage
}

output "workflow" {
  description = "Cloud Workflows permissions structure."
  value       = local.workflow
}

output "recaptcha" {
  description = "Recaptcha permissions structure."
  value       = local.recaptcha
}
