/*******************
 * Creates AWS S3 Buckets required for api and transcode to function properly
 *******************/

terraform {
  required_version = ">= 0.12"
}

module "assets" {
  source = "../s3.public-read"

  prefix       = "dbl-assets"
  is_versioned = true

  cors_rules = [{
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]

    allowed_origins = ["*"]
    expose_headers  = ["Content-Length", "Content-Type", "ETag"]
    max_age_seconds = 3000
  }]

  tags = {
    name        = "assets"
    environment = var.environment
    scope       = var.scope
  }
}

module "video_in" {
  source = "../s3.public-read"

  prefix       = "dbl-video-in"
  is_versioned = true

  cors_rules = [{
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["Content-Length", "Content-Type", "ETag"]
    }, {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["Content-Length", "Content-Type", "ETag"]
  }]

  tags = {
    name        = "video-in"
    environment = var.environment
    scope       = var.scope
  }
}

module "video_out" {
  source = "../s3.public-read"

  prefix       = "dbl-video-out"
  is_versioned = true

  cors_rules = [{
    allowed_headers = ["Content-Type", "x-amz-acl", "origin"]
    allowed_methods = ["PUT"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
    }, {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }]

  tags = {
    name        = "video-out"
    environment = var.environment
    scope       = var.scope
  }
}

# resource "aws_s3_bucket" "video-out" {
#   bucket_prefix = "dbl-video-out-"

#   cors_rule {
#     allowed_headers = ["Content-Type", "x-amz-acl", "origin"]
#     allowed_methods = ["PUT"]
#     allowed_origins = ["*"]
#     max_age_seconds = 3000
#   }

#   cors_rule {
#     allowed_headers = ["*"]
#     allowed_methods = ["GET"]
#     allowed_origins = ["*"]
#     max_age_seconds = 3000
#   }

#   versioning {
#     enabled = true
#   }

#   tags = {
#     name        = "video-out"
#     environment = var.environment
#     scope       = var.scope
#   }
# }
