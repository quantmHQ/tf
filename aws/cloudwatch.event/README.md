# AWS S3 modules for Cloudwatch events

Terraform Module that creates cloudwatch event rule and target.

## Inputs

| Name                   | Description                         |  Type  | Default | Required |
| ---------------------- | ----------------------------------- | :----: | :-----: | :------: |
| name                   | The name of resource                | string |  null   |   yes    |
| environment            | The environment of the resources    | string |  null   |   yes    |
| pipeline_source_bucket | The source code bucket for pipeline | string |  null   |   yes    |
| key                    | object key for monitorning          | string |  null   |   yes    |
| target_id              | The target ID of event              | string |  null   |   yes    |
| code_pipeline_arn      | code pipeline arn to trigger        | string |  null   |   yes    |

## Outputs

| Name | Description                    |
| ---- | ------------------------------ |
| name | aws cloudwatch event rule name |
