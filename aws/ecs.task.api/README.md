# AWS module for ecs service and task defination

Terraform Module that creates ECS task definition

## Inputs

| Name           | Description                      |  Type  | Default | Required |
| -------------- | -------------------------------- | :----: | :-----: | :------: |
| environment    | The environment of the resources | string |  null   |   yes    |
| task_name      | name of the resource             | string |  null   |   yes    |
| role           | IAM role                         | string |  null   |   yes    |
| task_variables | task defination data             | string |  null   |   yes    |

## Outputs

| Name | Description     |
| ---- | --------------- |
| task | ecs task object |
