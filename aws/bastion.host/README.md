# AWS instance module for bastion host

Terraform Module that creates aws_instance, security group and aws key pair

## Inputs

| Name        | Description                     |  Type  | Default | Required |
| ----------- | ------------------------------- | :----: | :-----: | :------: |
| vpc         | object of virtual private cloud | string |  null   |   yes    |
| subnet_id   | public subnet id                | string |  null   |   yes    |
| cidr_blocks | public subnet cidr block        | string |  null   |   yes    |

## Output

| Name      | Description                   |
| --------- | ----------------------------- |
| public_ip | public ip address of instance |
