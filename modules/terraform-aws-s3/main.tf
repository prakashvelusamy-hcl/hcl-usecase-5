resource "aws_s3_bucket" "raw" {
  bucket = "prakash-hcl-non-resized"

  tags = {
    Name        = "non-resized"
  }
}

resource "aws_s3_bucket" "resized" {
  bucket = "prakash-hcl-resized"

  tags = {
    Name        = "non-resized"
  }
}