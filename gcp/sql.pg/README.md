# GCP Cloud SQL PostgreSQL Terraform Module

## Description

This Terraform module creates and manages a Google Cloud SQL PostgreSQL instance on GCP.

It facilitates the provisioning of:

*   A Cloud SQL PostgreSQL instance with configurable engine version, tier, and disk size.
*   Private IP connectivity within a specified VPC network (Google Managed Services connection).
*   Optional High Availability (Regional) configuration.
*   Optional Cloud SQL Insights enablement.
*   Customizable database flags.
*   Deletion protection configuration.
*   A specific database within the instance.
*   A database user with a randomly generated secure password.

## Usage Example

```hcl
module "pg_database" {
  source = "./modules/sql.pg" # Or path/URL to your module

  name        = "my-app-db"
  project     = "your-gcp-project-id"
  environment = "dev"
  region      = "us-central1"
  network     = "projects/your-gcp-project-id/global/networks/your-vpc-name" # Or self-link

  database_name = "application_db"
  database_user = "app_user"

  // Optional overrides
  engine          = "POSTGRES_16"
  tier            = "db-custom-2-7680"
  disk            = 50
  is_ha           = true
  enable_insights = true
  database_flags = {
    "log_connections" = "on"
    "log_statement"   = "ddl"
  }
  delete_protection = true
}

output "db_instance_ip" {
  description = "Private IP address of the Cloud SQL instance."
  value       = module.pg_database.ip
}

output "db_user_password" {
  description = "Generated password for the database user."
  value       = module.pg_database.password
  sensitive   = true
}
```

## Requirements

*   Terraform v0.13+
*   Google Provider for Terraform

## Inputs

| Name              | Description                                                                                                | Type          | Default        | Required |
| :---------------- | :--------------------------------------------------------------------------------------------------------- | :------------ | :------------- | :------: |
| `name`            | The name of the Cloud SQL PostgreSQL instance. The environment name will be appended.                        | `string`      | -              |   yes    |
| `project`         | The ID of the Google Cloud project where the instance will be created.                                     | `string`      | -              |   yes    |
| `environment`     | The deployment environment (e.g., 'dev', 'stg', 'prd'). Used for naming/labeling.                           | `string`      | -              |   yes    |
| `region`          | The GCP region for the Cloud SQL instance.                                                                 | `string`      | -              |   yes    |
| `network`         | The self-link or name of the VPC network for private IP connectivity. Private service connection is setup. | `string`      | -              |   yes    |
| `engine`          | The database engine type and version (e.g., 'POSTGRES_15').                                                | `string`      | `POSTGRES_16`  |    no    |
| `tier`            | The machine type tier for the Cloud SQL instance (e.g., 'db-f1-micro', 'db-custom-2-7680').                  | `string`      | `db-f1-micro`  |    no    |
| `disk`            | The size of the data disk in GB.                                                                           | `number`      | `10`           |    no    |
| `is_ha`           | Enable High Availability. If true, creates a Regional instance with SSD disk and enables backups. If false, creates a Zonal instance. | `bool`        | `false`        |    no    |
| `enable_insights` | Enable Cloud SQL Insights for query monitoring and diagnostics.                                              | `bool`        | `false`        |    no    |
| `database_flags`  | A map of database flags to apply to the instance (e.g., { 'log_connections' = 'on' }).                      | `map(string)` | `{}`           |    no    |
| `delete_protection`| Enable deletion protection for the Cloud SQL instance. Recommended for production environments.              | `bool`        | `true`         |    no    |
| `database_name`   | The name of the database to create within the instance.                                                    | `string`      | -              |   yes    |
| `database_user`   | The username for the database user to create within the instance.                                          | `string`      | -              |   yes    |

## Outputs

| Name       | Description                                                                            | Sensitive |
| :--------- | :------------------------------------------------------------------------------------- | :-------: |
| `self_link`| The self-link of the created Cloud SQL instance.                                       |    no     |
| `ip`       | The private IP address assigned to the Cloud SQL instance within the specified VPC network. |    no     |
| `password` | The randomly generated password for the database user.                                 |    yes    |

```
