# AWS S3 modules for creating ECR

Terraform Module that creates ECR(Elastic Container Registry Repository)

## Inputs

| Name        | Description                      |  Type  | Default | Required |
| ----------- | -------------------------------- | :----: | :-----: | :------: |
| name        | The name of resource             | string |  null   |   yes    |
| environment | The environment of the resources | string |  null   |   yes    |

## Outputs

| Name        | Description      |
| ----------- | ---------------- |
| respositery | aws ecr instance |
