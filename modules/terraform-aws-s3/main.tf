resource "aws_s3_bucket" "raw" {
  bucket = var.bucket_1

  tags = {
    Name        = "non-resized"
  }
}

resource "aws_s3_bucket" "resized" {
  bucket = var.bucket_2

  tags = {
    Name        = "resized"
  }
}