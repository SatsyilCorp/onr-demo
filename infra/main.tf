# ==============================================================================
# OpenTofu Infrastructure - FedRAMP High / DoD IL5 Compliant Baseline
# ==============================================================================

# Customer-Managed KMS Key for Envelope Encryption
resource "aws_kms_key" "enterprise_kms_key" {
  description             = "Customer Managed Key for Enterprise Analytics & Lakehouse Encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name = "kms-key-${var.environment}"
  }
}

# Secure Isolated VPC (Zero Public Subnets for Data Layer)
resource "aws_vpc" "enterprise_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-analytics-${var.environment}"
  }
}

# Private Subnet for Analytics and Lakehouse Nodes
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.enterprise_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "subnet-private-a-${var.environment}"
  }
}

# Hardened S3 Bucket for Analytics & Lakehouse Storage
resource "aws_s3_bucket" "analytics_lakehouse" {
  bucket_prefix = "enterprise-lakehouse-${var.environment}-"
  force_destroy = false
}

resource "aws_s3_bucket_versioning" "analytics_versioning" {
  bucket = aws_s3_bucket.analytics_lakehouse.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "analytics_encryption" {
  bucket = aws_s3_bucket.analytics_lakehouse.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.enterprise_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "analytics_block_public" {
  bucket = aws_s3_bucket.analytics_lakehouse.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Dynamic GPU Compute Cluster (Provisioned on-demand to control FinOps costs)
resource "aws_launch_template" "gpu_compute_template" {
  count         = var.enable_gpu_cluster ? 1 : 0
  name_prefix   = "gpu-node-template-${var.environment}-"
  instance_type = var.gpu_instance_type

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 100
      volume_type           = "gp3"
      encrypted             = true
      kms_key_id            = aws_kms_key.enterprise_kms_key.arn
      delete_on_termination = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # IMDSv2 strictly enforced (DoD IL5)
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "gpu-analytics-node-${var.environment}"
    }
  }
}
