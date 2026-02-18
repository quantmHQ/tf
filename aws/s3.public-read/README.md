# AWS S3 bucket module with bucket policy

Terraform Module that implements a CloudFront Distribution (CDN) for a custom origin ( e.g website)

## Inputs

| Name         | Description                                               |  Type  | Default  | Required |
| ------------ | --------------------------------------------------------- | :----: | :------: | :------: |
| name         | name of the bucket, if prefix is given, this is not taken | string |   null   |   yes    |
| prefix       | prefix of the bucket                                      | string |   null   |    no    |
| is_versioned | check if the bucket is versioned or not                   |  bool  |  false   |    no    |
| cors_rules   | list of cors_rule in terraform format                     |  list  |    []    |   yes    |
| tags         | tags to apply to the bucket                               |  map   | `` | yes |
| website      | A website object for static website hosting               |  map   |   null   |    no    |

## Outputs

| Name   | Description          |
| ------ | -------------------- |
| bucket | returns bucket value |
