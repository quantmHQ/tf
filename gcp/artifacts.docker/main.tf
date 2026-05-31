resource "google_artifact_registry_repository" "default" {
  project       = var.project
  location      = var.location
  repository_id = "${var.name}-${var.environment}"
  description   = var.description != "" ? var.description : "${var.name} Docker repository for ${var.environment} environment"
  format        = "DOCKER"

  labels = {
    name        = var.name
    environment = var.environment
  }
}

# --- IAM Binding for Read-Only Service Accounts ---

resource "google_artifact_registry_repository_iam_binding" "readonly" {
  count = length(var.service_account_r) > 0 ? 1 : 0

  project    = var.project
  repository = google_artifact_registry_repository.default.name
  location   = google_artifact_registry_repository.default.location
  role       = "roles/artifactregistry.reader"

  members = [
    for email in var.service_account_r : "serviceAccount:${email}"
  ]

  depends_on = [google_artifact_registry_repository.default]
}

# --- IAM Binding for Read-Write Service Accounts ---

resource "google_artifact_registry_repository_iam_binding" "full" {
  count = length(var.service_account_rw) > 0 ? 1 : 0

  project    = var.project
  repository = google_artifact_registry_repository.default.name
  location   = google_artifact_registry_repository.default.location
  role       = "roles/artifactregistry.writer"

  members = [
    for email in var.service_account_rw : "serviceAccount:${email}"
  ]

  depends_on = [google_artifact_registry_repository.default] # Added for consistency
}

# --- IAM Binding for Public Access (Conditional) ---

resource "google_artifact_registry_repository_iam_binding" "public" {
  count = var.public ? 1 : 0

  project    = var.project
  repository = google_artifact_registry_repository.default.name
  location   = google_artifact_registry_repository.default.location
  role       = "roles/artifactregistry.reader"

  members = [
    "allUsers",
  ]

  depends_on = [google_artifact_registry_repository.default] # Added for consistency
}
