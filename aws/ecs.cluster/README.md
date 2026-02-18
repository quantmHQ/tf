# AWS module for ecs service and task defination

Terraform Module that creates ECS task definition, service and its security group

## Inputs

| Name        | Description                      |  Type  | Default | Required |
| ----------- | -------------------------------- | :----: | :-----: | :------: |
| environment | The environment of the resources | string |  null   |   yes    |
| name        | name of the resource             | string |  null   |   yes    |

## Outputs

| Name       | Description                                                |
| ---------- | ---------------------------------------------------------- |
| cluster_id | The Amazon Resource Name (ARN) that identifies the cluster |
