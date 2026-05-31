resource "google_storage_bucket" "default" {
  name                        = "${var.environment}-${var.name}"
  project                     = var.project
  location                    = var.location
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  dynamic "cors" {
    # This block is active if enable_cors is TRUE
    for_each = var.enable_cors ? [1] : []

    content {
      origin          = ["*"]
      method          = ["*"]
      response_header = ["*"]
      max_age_seconds = 3600
    }
  }

  dynamic "cors" {
    # This block is active if enable_cors is FALSE AND public is TRUE.
    # Applies a single CORS rule focused on public read and preflight methods.
    for_each = !var.enable_cors && var.public ? [1] : []

    content {
      origin          = ["*"]
      method          = ["GET", "HEAD", "OPTIONS"]
      max_age_seconds = 3600
    }
  }

  force_destroy = var.force_destroy
}

# --- IAM Binding for Read-Only Service Accounts ---
resource "google_storage_bucket_iam_binding" "readonly" {
  count = length(var.service_account_r) > 0 || var.public ? 1 : 0

  bucket = google_storage_bucket.default.name
  role   = "roles/storage.objectViewer"

  members = concat(
    [for email in var.service_account_r : "serviceAccount:${email}"],
    var.public ? ["allUsers"] : []
  )

  depends_on = [google_storage_bucket.default]
}

# --- IAM Binding for Read-Write Service Accounts ---
# Note: Using roles/storage.objectAdmin which allows object read, write, delete, and listing.
# Adjust role if needed (e.g., roles/storage.legacyBucketWriter for only create/overwrite)
resource "google_storage_bucket_iam_binding" "full" {
  count = length(var.service_account_rw) > 0 ? 1 : 0

  bucket = google_storage_bucket.default.name
  role   = "roles/storage.objectAdmin"

  members = [
    for email in var.service_account_rw : "serviceAccount:${email}"
  ]

  depends_on = [google_storage_bucket.default]
}
