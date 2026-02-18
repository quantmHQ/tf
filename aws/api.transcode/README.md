# AWS module for SQS, SNS and Elastic Transcoder

Terraform Module that creates random number, SNS topic, SQS queue and elastic transcoder

## Inputs

| Name             | Description                       |  Type  | Default | Required |
| ---------------- | --------------------------------- | :----: | :-----: | :------: |
| environment      | The environment of the resources  | string |  null   |   yes    |
| scope            | The scope of the resources        | string |  null   |    no    |
| role             | ID of IAM role to create resource | string |  null   |    no    |
| video-in-bucket  | S3 bucket to watch for videos     | string |  null   |   yes    |
| video-out-bucket | S3 bucket to put encoded videos   | string |  null   |   yes    |

## Outputs

| Name        | Description                                  |
| ----------- | -------------------------------------------- |
| sqs         | returns value of sqs                         |
| sns         | returns value of sns                         |
| pipeline_id | returns value of elastic transcoder pipeline |
