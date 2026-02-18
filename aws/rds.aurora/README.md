# AWS module for rds_cluster

Terraform Module that creates RDS cluster and its subnet group

## Inputs

| Name              | Description                      |  Type  | Default | Required |
| ----------------- | -------------------------------- | :----: | :-----: | :------: |
| environment       | The environment of the resources | string |  null   |   yes    |
| scope             | The scope of the resources       | string |  null   |   yes    |
| db_cluster_name   | name of the database cluster     | string |  null   |   yes    |
| sg_name           | name of subnet group             | string |  null   |   yes    |
| db_name           | name of the database             | string |  null   |   yes    |
| db_user           | user name of database            | string |  null   |   yes    |
| db_pass           | database password of database    | string |  null   |   yes    |
| private_subnet_id | ID of private subnets            | string |  null   |   yes    |
| security_group    | security group object            |        |  null   |   yes    |

## Outputs

| Name    | Description                            |
| ------- | -------------------------------------- |
| db_host | returns value of database host endoint |
