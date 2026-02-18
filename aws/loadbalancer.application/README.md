# Load Balancer module with security group

Configuration in this modules create application load balancer, security group, target group and its listener

## Intputs

| Name              | Description                             | Type         | Default                     | Required |     |
| ----------------- | --------------------------------------- | ------------ | --------------------------- | -------- | --- |
| lb_name           | Name of load balancer                   | string       | ``| yes                     |
| target_group_name | Target group name                       | string       | ``| yes                     |
| vpc               | virtual private cloud instance          | string       | ``| yes                     |
| public_subnet_ids | List of public subnet ids               | list(string) | ``| yes                     |
| certificate_arn   | certificate to attach on https listener | string       | ``| yes                     |
| ssl_policy        | security policy for https listener      | string       | `ELBSecurityPolicy-2016-08` | No       |
| environment       | Environment name                        | string       | ``| yes                     |
| security_group    | security group object                   | instance     | `` | yes                    |
| lb_zone_id        | load balancer zone id                   | string       | ``| yes                     |
| record_name       | aws route53 record name                 | string       | `` | yes                    |
| domain_name       | aws route53 domain name                 | string       | ``| yes                     |
| zone_id           | aws route53 zone id                     | string       | ``| yes                     |

## Outputs

| Name             | Description                   |
| ---------------- | ----------------------------- |
| alb              | load balancer resource object |
| alb_target_group | load balancer target group    |
| record_fqdn      | load balancer record name     |
