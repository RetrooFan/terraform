terraform {
  backend "s3" {
    bucket       = "krzysieksobol93-terraform-states"
    key          = "terraform-backend.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
    encrypt      = true
    profile      = "krzysieksobol93"
  }
}

resource "aws_s3_bucket" "terraform_states" {
  bucket        = "krzysieksobol93-terraform-states"
  force_destroy = false
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_states.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.terraform_states.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state_public_block" {
  bucket = aws_s3_bucket.terraform_states.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "state_lifecycle" {
  bucket = aws_s3_bucket.terraform_states.id

  rule {
    id     = "keep-at-least-10-versions-delete-after-30-days"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days           = 30
      newer_noncurrent_versions = 10
    }
  }
}
