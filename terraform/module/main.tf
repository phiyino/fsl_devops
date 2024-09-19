resource "aws_s3_bucket" "example" {
  bucket = "${var.project_name}-${var.env}"

  tags = {
    Name        = "My bucket"
    Environment = var.env
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.example.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "example" {
    bucket = aws_s3_bucket.example.id

    policy = jsonencode(
        {
            Version= "2012-10-17"
            Statement=[
                {
                    Effect="Allow"
                    Principal="*"
                    Action="s3:GetObject"
                    Resource= "${aws_s3_bucket.example.arn}/*"
                }
            ]
        }
    )
  
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  index_document {
    suffix = "index.html"
  }

}