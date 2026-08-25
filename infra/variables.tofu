variable "aws_region" {
  type        = string
  description = "AWS region where the Databricks workspace and networking will be deployed."
  default     = "us-east-1"
}

variable "databricks_account_id" {
  type        = string
  description = "Databricks Account ID (MWS UUID)."
  default     = "16f11672-8169-4ec3-a0cd-62eca6f3fe8e"
}

variable "environment" {
  type        = string
  description = "Deployment target environment (dev, test, prod)."
  default     = "dev"
}
