# AWS module for elasticache_cluster

Terraform Module that creates elasticache cluster and its subnet group

## Inputs

| Name               | Description                      |  Type  | Required |
| ------------------ | -------------------------------- | :----: | :------: |
| environment        | The environment of the resources | string |   yes    |
| redis_cluster_name | name of the cluster              | string |   yes    |
| security_group     | security group instance          | string |   yes    |
| private_subnet_ids | List of private subnet IDs       | string |   yes    |
| sg_name            | name of subnet group             | string |   yes    |

## Outputs

| Name       | Description                            |
| ---------- | -------------------------------------- |
| redis_host | returns value of elastic cache cluster |
