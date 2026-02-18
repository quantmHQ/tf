# BREU Terraform Modules

This repository contains a collection of reusable, production-ready Terraform modules for Google Cloud Platform (GCP). These modules are designed to accelerate infrastructure provisioning while adhering to security best practices and organizational standards.

## Design Philosophy

### Principle of Least Privilege (PoLP)

Security is a first-class citizen in this library. The core of our security model is the **`permissions`** module.

*   **Baseline:** The `permissions` module defines granular, task-specific permission sets (e.g., `read`, `write`, `execute`) rather than relying on broad, pre-defined GCP roles (like `roles/editor`).
*   **Integration:** All other modules (`run`, `bucket`, `sql`, etc.) are designed to work seamlessly with the custom roles or service accounts configured using the `permissions` module.
*   **Recommendation:** When assigning access to resources created by these modules, always prefer the fine-grained definitions from the `permissions` module over default GCP roles to minimize the blast radius of compromised credentials.

## Available Modules

| Module | Description | Path |
| :--- | :--- | :--- |
| **Permissions** | **The Foundation.** Provides granular IAM permission sets for PoLP. | [`gcp/permissions`](./gcp/permissions) |
| **Artifact Registry** | Provisions Docker repositories with standardized naming and access control. | [`gcp/artifacts.docker`](./gcp/artifacts.docker) |
| **Cloud Storage** | Creates secure GCS buckets with versioning and uniform access control. | [`gcp/bucket`](./gcp/bucket) |
| **Networking** | Sets up VPCs, subnets, NAT, and basic firewalls. | [`gcp/networking`](./gcp/networking) |
| **Cloud Run Service** | Deploys scalable, containerized HTTP services (v2). | [`gcp/run.svc`](./gcp/run.svc) |
| **Cloud Run Job** | Deploys batch processing jobs on Cloud Run (v2). | [`gcp/run.job`](./gcp/run.job) |
| **Cloud Run Worker** | Deploys worker pools with sidecar support (e.g., OpenTelemetry) for background tasks. | [`gcp/run.worker`](./gcp/run.worker) |
| **Cloud SQL (PG)** | Provisions PostgreSQL instances with private IP and secure defaults. | [`gcp/sql.pg`](./gcp/sql.pg) |

## Usage

To use a module, reference it in your Terraform configuration. We recommend pinning to specific tags or commits for stability in production environments.

```hcl
module "my_service" {
  source = "./tf/gcp/run.svc" # Or git source

  name            = "my-app"
  project         = var.project_id
  environment     = "prod"
  region          = "us-central1"
  service_account = module.service_account.email
  
  # ... module specific configuration
}
```

## Prerequisites

*   **Terraform:** v1.0+
*   **Google Cloud SDK:** Installed and authenticated.
*   **Provider:** `hashicorp/google` provider configured in your root module.

## Contribution

When adding or modifying modules:
1.  Ensure `README.md` is updated in the specific module directory.
2.  Adhere to the `permissions` module baseline for any IAM bindings.
3.  Run `terraform fmt` before committing.