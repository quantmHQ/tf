terraform {
  required_version = ">= 0.12"
}

/*
 * To understand conditionally omitted arguments, see
 *  https://www.hashicorp.com/blog/terraform-0-12-conditional-operator-improvements/
 *
 *
 * The `count`, `for_each` and `for` arguments do not render if the count is 0, or
 * the list is empty. To understand more about each, see
 * https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
 */

resource "aws_s3_bucket" "default" {
  bucket        = var.prefix != null ? null : var.name
  bucket_prefix = var.prefix != null ? "${var.prefix}-" : null

  versioning {
    enabled = var.is_versioned
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  // dynamically populating cors_rules
  dynamic "cors_rule" {
    for_each = var.cors_rules

    content {
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      allowed_methods = lookup(cors_rule.value, "allowed_methods", null)
      allowed_origins = lookup(cors_rule.value, "allowed_origins", null)
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", null)
    }
  }

  // dynamically populating website rules
  dynamic "website" {
    for_each = var.website != null ? [var.website] : []

    content {
      index_document           = lookup(website.value, "index_document", null)
      error_document           = lookup(website.value, "error_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules            = lookup(website.value, "routing_rules", null)
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.default.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.default.bucket
  policy = templatefile("${path.module}/templates/policy.s3.public-read.json", {
    bucket = aws_s3_bucket.default.bucket
  })

  depends_on = [
    aws_s3_bucket_public_access_block.default,
  ]
}
