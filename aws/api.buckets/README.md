# AWS S3 buckets module for creating buckets used in transcoding

Terraform Module that creates s3 buckets used in transcoding

## Inputs

| Name        | Description                                               |  Type  | Default | Required |
| ----------- | --------------------------------------------------------- | :----: | :-----: | :------: |
| environment | name of the bucket, if prefix is given, this is not taken | string |  null   |   yes    |
| scope       | prefix of the bucket                                      | string |  null   |    no    |

## Outputs

| Name   | Description                |
| ------ | -------------------------- |
| bucket | returns bucket value names |
