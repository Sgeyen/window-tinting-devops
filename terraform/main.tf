provider "aws" {
  region                  = "us-east-2"
  access_key              = var.aws_access_key
  secret_key              = var.aws_secret_key
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

##########################################
# S3 Bucket for MongoDB Backups
# - Stores compressed backup files
# - Publicly readable and listable (on purpose)
##########################################

resource "aws_s3_bucket" "mongo_backup" {
  bucket = "${var.cluster_name}-mongo-backups-${random_id.suffix.hex}"
  acl    = "public-read"

  tags = {
    Name = "${var.cluster_name}-mongo-backup"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket_public_access_block" "mongo_backup_block" {
  bucket = aws_s3_bucket.mongo_backup.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "mongo_backup_policy" {
  bucket = aws_s3_bucket.mongo_backup.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "AllowPublicRead",
      Effect    = "Allow",
      Principal = "*",
      Action    = [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      Resource = [
        "${aws_s3_bucket.mongo_backup.arn}",
        "${aws_s3_bucket.mongo_backup.arn}/*"
      ]
    }]
  })
}
