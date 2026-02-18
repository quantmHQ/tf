# AWS module for security group

Terraform Module that creates security groups

## Inputs

| Name                | Description                      |     Type     | Default | Required |
| ------------------- | -------------------------------- | :----------: | :-----: | :------: |
| sg_name             | name of subnet group             |    string    |  null   |   yes    |
| environment         | The environment of the resources |    string    |  null   |   yes    |
| ingress_ports       | list of ingress port numbers     | list(number) |  null   |   yes    |
| ingress_cidr_blocks | list of cidr blocks              | list(string) |  null   |   yes    |
| security_group      | list of security group id        | list(string) |  null   |   yes    |

## Outputs

| Name           | Description           |
| -------------- | --------------------- |
| security_group | security group object |
