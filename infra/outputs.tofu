output "workspace_url" {
  description = "URL of the provisioned Databricks workspace."
  value       = module.databricks_workspace.workspace_url
}

output "workspace_id" {
  description = "Databricks Workspace ID."
  value       = module.databricks_workspace.workspace_id
}

output "workspace_status" {
  description = "Status of the Databricks workspace deployment."
  value       = module.databricks_workspace.workspace_status
}

output "vpc_id" {
  description = "ID of the AWS VPC created for compute nodes."
  value       = module.databricks_workspace.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets hosting Databricks clusters."
  value       = module.databricks_workspace.private_subnet_ids
}

output "public_subnet_ids" {
  description = "IDs of the public subnets hosting the NAT Gateway."
  value       = module.databricks_workspace.public_subnet_ids
}

output "security_group_id" {
  description = "ID of the security group attached to Databricks compute nodes."
  value       = module.databricks_workspace.security_group_id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket created for Databricks root storage."
  value       = module.databricks_workspace.s3_bucket_name
}

output "iam_role_arn" {
  description = "ARN of the AWS IAM cross-account role used by Databricks."
  value       = module.databricks_workspace.iam_role_arn
}

output "metastore_id" {
  description = "Unity Catalog Metastore ID."
  value       = module.databricks_workspace.metastore_id
}

output "metastore_name" {
  description = "Unity Catalog Metastore Name."
  value       = module.databricks_workspace.metastore_name
}
