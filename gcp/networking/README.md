# VPC Module for Google Cloud Platform (GCP)

This Terraform module creates a Virtual Private Cloud (VPC) network and related resources in Google Cloud Platform (GCP). It allows you to define subnets, configure routing and NAT, and set up basic firewall rules.

## Features

*   Creates a VPC network with customizable name, environment, and project.
*   Creates subnets in specified regions with customizable CIDR blocks and descriptions.
*   Configures a Cloud Router for dynamic routing.
*   Configures Cloud NAT gateway for each region defined in the subnets.
*   Sets up basic firewall rules to allow egress traffic to the internet and ingress traffic for ICMP, SSH (port 22), HTTP (port 80), and HTTPS (port 443).
*   Supports IPv6

## Prerequisites

*   Terraform installed (version >= 1.0).
*   A Google Cloud Platform project.
*   The Google Cloud SDK installed and configured with appropriate credentials.
*   Terraform service account has the `roles/compute.networkAdmin` and `roles/compute.securityAdmin` permissions.

## Usage

To use the module, you need to define the required variables in a `terraform.tfvars` file or pass them as command-line arguments.

```terraform
module "vpc" {
  source      = "./modules/vpc"
  project     = "your-gcp-project-id"
  environment = "dev"
  name        = "my-vpc"

  subnets = {
    subnet-us-east1 = {
      cidr        = "10.10.1.0/24"
      region      = "us-east1"
      description = "Subnet in us-east1"
    },
    subnet-us-west1 = {
      cidr        = "10.10.2.0/24"
      region      = "us-west1"
      description = "Subnet in us-west1"
    }
  }
}
```

### Example `terraform.tfvars`

```terraform
project     = "your-gcp-project-id"
environment = "dev"
name        = "my-vpc"

subnets = {
  subnet-us-east1 = {
    cidr        = "10.10.1.0/24"
    region      = "us-east1"
    description = "Subnet in us-east1"
  },
  subnet-us-west1 = {
    cidr        = "10.10.2.0/24"
    region      = "us-west1"
    description = "Subnet in us-west1"
  }
}
```

### Steps

1.  **Clone the repository (if necessary):**  If the module code is not already in your project, clone it or copy the relevant files.

2.  **Create a `terraform.tfvars` file:** Define the necessary variables like `project`, `environment`, `name`, and `subnets`.

3.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

4.  **Plan the changes:**

    ```bash
    terraform plan
    ```

5.  **Apply the changes:**

    ```bash
    terraform apply
    ```

## Variables

| Name          | Type   | Description                                                                                                        | Default |
| ------------- | ------ | ------------------------------------------------------------------------------------------------------------------ | ------- |
| `project`     | string | GCP Project ID                                                                                                     |         |
| `environment` | string | Environment name (e.g., `dev`, `staging`, `prod`)                                                                 |         |
| `name`        | string | Name of the VPC network                                                                                            |         |
| `subnets`     | map    | A map of subnets, where each key is the subnet name and each value is an object containing `cidr`, `region` and optional `description` and `dual_stack` attributes.                                                 |         |

### `subnets` Object Attributes

| Name          | Type    | Description                                                              | Required |
| ------------- | ------- | ------------------------------------------------------------------------ | -------- |
| `cidr`        | string  | The CIDR block for the subnet. Must be a valid CIDR block.           | Yes      |
| `region`      | string  | The region where the subnet will be created.                            | Yes      |
| `description` | string  | (Optional) A description for the subnet.                                | No       |
| `dual_stack`  | bool  | (Optional) Enable IPv6. Default is `false`.                            | No       |

## Outputs

The module doesn't currently define explicit outputs.  You can add output variables in the `outputs.tf` file if you need to export specific values, such as the VPC ID, subnet IDs, etc.  For example:

```terraform
output "vpc_id" {
  description = "The ID of the VPC network."
  value       = google_compute_network.default.id
}

output "subnet_ids" {
  description = "A map of subnet names to their IDs."
  value = {
    for k, subnet in google_compute_subnetwork.default : k => subnet.id
  }
}
```

Then you can access those outputs using `terraform output`.

## Customization

*   **Firewall Rules:**  The module provides very basic firewall rules.  You should modify the `google_compute_firewall` resources to implement more specific and restrictive rules based on your security requirements.
*   **Subnet Secondary Ranges:**  The module doesn't currently support defining secondary IP ranges for the subnets.  You can add that functionality by modifying the `google_compute_subnetwork` resource configuration.
*   **Routing Mode:** The default routing mode is "GLOBAL".  You can change this to "REGIONAL" by modifying the `routing_mode` attribute in the `google_compute_network` resource.
*   **NAT Configuration:** The NAT configuration is basic.  You can customize it further by adding attributes to the `google_compute_router_nat` resource, such as specifying minimum and maximum ports per VM, and enabling logging.
*   **Adding Network Tags:** You can add network tags to the VPC and subnets to further refine firewall rules and other network policies.  Add the `tags` attribute to the `google_compute_network` and `google_compute_subnetwork` resources.
