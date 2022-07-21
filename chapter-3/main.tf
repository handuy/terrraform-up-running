provider "aws" {
  profile = "admin-general"
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "tf-state" {
  bucket = "tf-state-515462467908"

  tags = {
    Name = "TF state"
  }

  lifecycle {
      prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "versioning_tf-state" {
  bucket = aws_s3_bucket.tf-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf-state" {
  bucket = aws_s3_bucket.tf-state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "tf-state-lock" {
  name           = "tf-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "tf-state-lock"
  }
}