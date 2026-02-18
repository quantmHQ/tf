# lambda module to modify request header

Terraform Module that implements a lambda function which modify request header to accept compressed (gzip) content as reponse

## Inputs

| Name          | Description                               |  Type  |     Default     | Required |
| ------------- | ----------------------------------------- | :----: | :-------------: | :------: |
| function_name | Name for lambda function                  | string |    `` | yes     |
| role_arn      | Existing role to create lambda function   | string |    `` | yes     |
| handler       | The function entrypoint in your code      | string | `index.handler` |   yes    |
| runtime       | The identifier of the function's runtime. | string |   `nodjs10.`    |    no    |

## Outputs

| Name          | Description                      |
| ------------- | -------------------------------- |
| qualified_arn | qualified arn of lambda function |
