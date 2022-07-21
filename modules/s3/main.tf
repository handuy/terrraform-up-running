resource "aws_s3_bucket" "kops-state" {
  bucket = "kops-state-1-515462467908"
  force_destroy = true

  tags = {
    Name = "kops state"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.kops-state.id
  versioning_configuration {
    status = var.s3_versioning
  }
}