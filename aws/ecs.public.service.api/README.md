# AWS module for ecs service

Terraform Module that creates ECS service and its security group

## Inputs

| Name              | Description                      |     Type     | Default  | Required |
| ----------------- | -------------------------------- | :----------: | :------: | :------: |
| environment       | The environment of the resources |    string    | `` | yes |
| service_name      | name of the resource             |    string    | `` | yes |
| task              | ecs task object                  |    object    | `` | yes |
| cluster_id        | ecs cluster ID                   |    string    | `` | yes |
| vpc               | virtual private cloud            |              | `` | yes |
| subnet_ids        | list of private subnet ids       | list(string) | `` | yes |
| lb_security_group | load balancer security group     |    string    | `` | yes |
| assign_public_ip  | service public IP address        |     bool     | `` | yes |
| container_name    | load balancer container name     |    string    |   null   |   yes    |
| container_port    | load balancer container port     |    number    |   null   |   yes    |
| target_group_arn  | load balancer target group       |    string    |   null   |   yes    |
