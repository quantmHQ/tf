[
  {
    "name": "${name}-${stage}",
    "image": "${image}",
    "cpu": 128,
    "portMappings": ${port_mappings},
    "command": ${command},
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-create-group": "true",
        "awslogs-group": "${stage}/${name}",
        "awslogs-region": "us-west-2",
        "awslogs-stream-prefix": "${stage}"
      }
    },
    "environment": [
      {
        "name": "DD_AWS_ACCOUNT_ID",
        "value": "307124181734"
      },
      {
        "name": "DD_DBNAME",
        "value": "${db_name}"
      },
      {
        "name": "DD_DBUSER",
        "value": "${db_user}"
      },
      {
        "name": "DD_DBPASS",
        "value": "${db_pass}"
      },
      {
        "name": "DD_DBHOST",
        "value": "${db_host}"
      },
      {
        "name": "REDIS_HOST",
        "value": "${redis_host}"
      },
      {
        "name": "DD_API_DEBUG",
        "value": "TRUE"
      },
      {
        "name": "DD_API_STAGE",
        "value": "${stage}"
      },
      {
        "name": "DD_API_LOG_HANDLER",
        "value": "console"
      },
      {
        "name": "SQS_NAMESPACE",
        "value": "${sqs_namespace}"
      },
      {
        "name": "SNS_TRANSCODE_SUCCESS_TOPIC",
        "value": "${sns_transcode_success}"
      },
      {
        "name": "DD_VIDEO_IN",
        "value": "${video_in_bucket}"
      },
      {
        "name": "DD_VIDEO_OUT",
        "value": "${video_out_bucket}"
      },
      {
        "name": "DD_ASSETS_BUCKET",
        "value": "${assets_bucket}"
      },
      {
        "name": "TRANSCODE_PIPELINE_ID",
        "value": "${transcode_pipeline_id}"
      },
      {
        "name": "AWS_COGNITO_IDENTITY_POOL_ID",
        "value": "us-west-2:6d181ecd-d00f-4b30-bfcf-d061cffa324e"
      },
      {
        "name": "AWS_COGNITO_DEVELOPER_PROVIDED_NAME",
        "value": "login.doubledip.com"
      },
      {
        "name": "EMAIL_BASE_URL",
        "value": "${email_base_url}"
      },
      {
        "name": "ROOT_URLCONF",
        "value": "${root_url_conf}"
      },
      {
        "name": "STRIPE_API_KEY",
        "value" : "${stripe_api_key}"
      },
      {
        "name": "STRIPE_API_SECRET",
        "value" : "${stripe_api_secret}"
      },
      {
        "name": "DD_ACCOUNTS_EMAIL",
        "value" : "${accounts_email}"
      },
      {
        "name" : "DD_S3_PATH",
        "value" : "https://s3.us-west-2.amazonaws.com"
      },
      {
        "name" : "DD_FACEBOOK_APP_ID",
        "value": "${facebook_app_id}"
      },
      {
        "name" : "DD_TWITTER_SITE",
        "value" : "${twitter_site}"
      },
      {
        "name" : "DD_TWITTER_CREATOR",
        "value" : "${twitter_creator}"
      },
      {
        "name" : "DD_IP_INFO_API_KEY",
        "value" : "${ip_info_api_key}"
      }
    ]
  }
]
