module "databricks_workspace" {
  source = "git::https://github.com/SatsyilCorp/golden-pipelines.git//modules/databricks-workspace?ref=dev"

  workspace_name        = "onr-workspace"
  metastore_name        = "onr-workspace-metastore"
  databricks_account_id = var.databricks_account_id
  aws_region            = var.aws_region
  pricing_tier          = "PREMIUM"

  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]

  create_metastore = true

  tags = {
    Environment = var.environment
    ManagedBy   = "OpenTofu"
    Project     = "Databricks"
    CreatedBy   = "bharath.annamaneni@satsyil.com"
  }
}
