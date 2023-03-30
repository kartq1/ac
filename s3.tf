resource "aws_s3_bucket" "terraform" {
  bucket = var.s3_tfstate_name

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    # prevent_destroy = true
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_acl" "terraform" {
  bucket = aws_s3_bucket.terraform.id
  acl    = "private"
}
