output "kms_key_arn" {
  description = "Customer Managed KMS Key ARN"
  value       = aws_kms_key.enterprise_kms_key.arn
}

output "vpc_id" {
  description = "Enterprise Analytics VPC ID"
  value       = aws_vpc.enterprise_vpc.id
}

output "lakehouse_bucket_name" {
  description = "Lakehouse S3 Storage Bucket"
  value       = aws_s3_bucket.analytics_lakehouse.id
}
