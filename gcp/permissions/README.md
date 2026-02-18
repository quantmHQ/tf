# GCP Fine-Grained Permissions Terraform Module

This Terraform module provides structured sets of granular Google Cloud Platform (GCP) IAM permissions, designed with the **Principle of Least Privilege (PoLP)** and **Single Responsibility Principle (SRP)** in mind.

## Motivation

GCP's predefined IAM roles are powerful and convenient, but often grant broader access than necessary for specific tasks or personas (like a CI/CD pipeline, a specific application runtime, or a read-only user). Granting excessive permissions increases the potential blast radius in case of compromised credentials or misconfiguration.

This module addresses this by:

1.  **Granularity:** Breaking down permissions for common GCP services into fine-grained sets.
2.  **Structure:** Organizing permissions based on common access patterns: Read (`r`), Write (`w`), Execute/Runtime (`x`), and Superuser/Admin (`su`).
3.  **Reusability:** Providing a central, version-controlled definition of these permission sets, simplifying the creation of focused custom IAM roles.

By using this module, you can more easily construct custom roles tailored to specific needs, adhering strictly to the Principle of Least Privilege.

## Core Concept: Permission Levels

Permissions within this module are categorized using the following keys:

*   `r` (Read): Permissions typically required for viewing resource configuration, status, and metadata. Does not allow modification.
*   `w` (Write): Permissions required for modifying resource configuration, often used during CI/CD processes (e.g., updating a service, uploading an artifact). May include deletion of sub-resources (like artifacts within a repo).
*   `x` (Execute/Runtime): The minimum permissions required for a service or application to *operate* or *interact* with the resource at runtime (e.g., download artifacts, invoke a Cloud Run service, encrypt/decrypt with KMS, publish to Pub/Sub, receive Eventarc events).
*   `su` (Superuser/Admin): Permissions for administering the resource's lifecycle and access control (e.g., creating/deleting top-level resources like Repositories or KMS KeyRings, setting IAM policies on the resource).

## Usage

First, include the module in your Terraform configuration:

```terraform
module "permissions" {
  source = "./relative/path/to/redux/devops/gcp/modules/permissions"
  # Or use a remote source like Git or Terraform Registry
}
```

Then, use the module outputs to construct custom IAM roles.

**Example 1: Creating a Read-Only Cloud SQL Viewer Role**

```terraform
resource "google_project_iam_custom_role" "cloudsql_viewer" {
  project     = "your-gcp-project-id"
  role_id     = "cloudsqlViewer"
  title       = "Cloud SQL Viewer"
  description = "Read-only access to Cloud SQL instances, databases, users, and backups."
  permissions = module.permissions.sql.r # Note: Output name is 'sql'
}

resource "google_project_iam_member" "sql_viewer_binding" {
  project = google_project_iam_custom_role.cloudsql_viewer.project
  role    = google_project_iam_custom_role.cloudsql_viewer.name
  member  = "user:viewer@example.com"
}
```

**Example 2: Creating a Role for a CI/CD Pipeline Deploying to Cloud Run**

This pipeline needs to:
*   Read Artifact Registry repos (`artifacts.repo.r`)
*   Upload Docker images (`artifacts.docker.w`)
*   Download Docker images (runtime dependency, often needed by build steps or Cloud Run itself) (`artifacts.docker.x`)
*   Update existing Cloud Run services (`run.svc.w`)
*   Get the status of Cloud Run services (`run.svc.r`)
*   Act as the Cloud Run service account during deployment (`iam.x`)
*   Potentially manage Eventarc triggers (`eventarc.su`) if the pipeline sets them up.

```terraform
resource "google_project_iam_custom_role" "cicd_cloud_run_deployer" {
  project     = "your-gcp-project-id"
  role_id     = "cicdCloudRunDeployer"
  title       = "CI/CD Cloud Run Deployer"
  description = "Permissions for CI/CD to build, push Docker images, and deploy to Cloud Run."
  permissions = distinct(concat(
    module.permissions.artifacts.repo.r,
    module.permissions.artifacts.docker.w,
    module.permissions.artifacts.docker.x,
    module.permissions.run.svc.r,
    module.permissions.run.svc.w,
    module.permissions.iam.x, # Allows acting as service accounts
    # module.permissions.eventarc.su, # Uncomment if CI/CD manages Eventarc triggers
    # Add other permissions if needed
  ))
}

resource "google_project_iam_member" "cicd_binding" {
  project = google_project_iam_custom_role.cicd_cloud_run_deployer.project
  role    = google_project_iam_custom_role.cicd_cloud_run_deployer.name
  member  = "serviceAccount:your-cicd-sa@your-gcp-project-id.iam.gserviceaccount.com"
}
```

**Example 3: Creating a Role for a Backend Application Runtime (e.g., Cloud Run Service)**

This application needs to:
*   Read configuration files from a GCS bucket (`storage.r`)
*   Publish messages to a Pub/Sub topic (`pubsub.x`)
*   Receive events via Eventarc (`eventarc.x`)
*   Write logs and metrics (`observe.x`)

```terraform
resource "google_project_iam_custom_role" "backend_app_runtime" {
  project     = "your-gcp-project-id"
  role_id     = "backendAppRuntime"
  title       = "Backend Application Runtime"
  description = "Runtime permissions for the backend application."
  permissions = distinct(concat(
    module.permissions.storage.r,  # Read from GCS
    module.permissions.pubsub.x,   # Publish to Pub/Sub topics, consume from subscriptions
    module.permissions.eventarc.x, # Receive Eventarc events
    module.permissions.observe.x,  # Write logs & metrics
  ))
}

resource "google_project_iam_member" "backend_app_binding" {
  project = google_project_iam_custom_role.backend_app_runtime.project
  role    = google_project_iam_custom_role.backend_app_runtime.name
  member  = "serviceAccount:your-backend-app-sa@your-gcp-project-id.iam.gserviceaccount.com"
}
```

## Services Covered

This module currently defines permission sets for the following GCP services:

*   Artifact Registry (`artifacts`: `repo`, `docker`, `maven`, `npm`, `python`)
*   Cloud Key Management Service (`kms`)
*   Cloud Run (`run`: `svc`, `job`)
*   Google Kubernetes Engine (`k8s`) - *Note: GKE permissions often interact with Kubernetes RBAC.*
*   Identity and Access Management (`iam`: Service Accounts)
*   Resource Manager (`resourcemanager`: Projects)
*   Cloud SQL (`sql`)
*   Observability (`observe`: Cloud Logging, Cloud Monitoring, Cloud Trace)
*   Cloud Storage (`storage`)
*   Cloud Pub/Sub (`pubsub`)
*   Cloud Eventarc (`eventarc`)

## Inputs

This module has no inputs.

## Outputs

The module exposes outputs corresponding to the services listed above (e.g., `artifacts`, `kms`, `run`, `k8s`, `iam`, `resourcemanager`, `sql`, `observe`, `storage`, `pubsub`, `eventarc`).

Most outputs are a map containing the permission levels (`r`, `w`, `x`, `su`) as keys. The value for each key is a list of GCP IAM permission strings relevant to that service and access level.

Some outputs, like `artifacts` and `run`, have an additional level of nesting based on the resource type within the service (e.g., `module.permissions.artifacts.docker.r`, `module.permissions.run.svc.x`).

Refer to the `*.tf` files within the module (especially `locals` blocks) for the specific permissions included in each list.
