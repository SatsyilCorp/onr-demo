# =============================================================================
# State Migration: Map root resources from databricks_workspace tfstate to module
# =============================================================================

moved {
  from = aws_vpc.this
  to   = module.databricks_workspace.aws_vpc.this
}

moved {
  from = aws_subnet.private
  to   = module.databricks_workspace.aws_subnet.private
}

moved {
  from = aws_subnet.public
  to   = module.databricks_workspace.aws_subnet.public
}

moved {
  from = aws_internet_gateway.this
  to   = module.databricks_workspace.aws_internet_gateway.this
}

moved {
  from = aws_eip.nat
  to   = module.databricks_workspace.aws_eip.nat
}

moved {
  from = aws_nat_gateway.this
  to   = module.databricks_workspace.aws_nat_gateway.this
}

moved {
  from = aws_route_table.public
  to   = module.databricks_workspace.aws_route_table.public
}

moved {
  from = aws_route_table.private
  to   = module.databricks_workspace.aws_route_table.private
}

moved {
  from = aws_route_table_association.public
  to   = module.databricks_workspace.aws_route_table_association.public
}

moved {
  from = aws_route_table_association.private
  to   = module.databricks_workspace.aws_route_table_association.private
}

moved {
  from = aws_security_group.databricks_sg
  to   = module.databricks_workspace.aws_security_group.databricks_sg
}

moved {
  from = aws_iam_role.cross_account
  to   = module.databricks_workspace.aws_iam_role.cross_account
}

moved {
  from = aws_iam_role_policy.cross_account
  to   = module.databricks_workspace.aws_iam_role_policy.cross_account
}

moved {
  from = time_sleep.wait_for_cross_account_role
  to   = module.databricks_workspace.time_sleep.wait_for_cross_account_role
}

moved {
  from = aws_s3_bucket.root_storage
  to   = module.databricks_workspace.aws_s3_bucket.root_storage
}

moved {
  from = aws_s3_bucket_versioning.root_storage
  to   = module.databricks_workspace.aws_s3_bucket_versioning.root_storage
}

moved {
  from = aws_s3_bucket_server_side_encryption_configuration.root_storage
  to   = module.databricks_workspace.aws_s3_bucket_server_side_encryption_configuration.root_storage
}

moved {
  from = aws_s3_bucket_public_access_block.root_storage
  to   = module.databricks_workspace.aws_s3_bucket_public_access_block.root_storage
}

moved {
  from = aws_s3_bucket_policy.root_storage
  to   = module.databricks_workspace.aws_s3_bucket_policy.root_storage
}

moved {
  from = databricks_mws_credentials.this
  to   = module.databricks_workspace.databricks_mws_credentials.this
}

moved {
  from = databricks_mws_storage_configurations.this
  to   = module.databricks_workspace.databricks_mws_storage_configurations.this
}

moved {
  from = databricks_mws_networks.this
  to   = module.databricks_workspace.databricks_mws_networks.this
}

moved {
  from = databricks_mws_workspaces.this
  to   = module.databricks_workspace.databricks_mws_workspaces.this
}

moved {
  from = aws_s3_bucket.metastore
  to   = module.databricks_workspace.aws_s3_bucket.metastore[0]
}

moved {
  from = aws_s3_bucket_versioning.metastore
  to   = module.databricks_workspace.aws_s3_bucket_versioning.metastore[0]
}

moved {
  from = aws_s3_bucket_server_side_encryption_configuration.metastore
  to   = module.databricks_workspace.aws_s3_bucket_server_side_encryption_configuration.metastore[0]
}

moved {
  from = aws_s3_bucket_public_access_block.metastore
  to   = module.databricks_workspace.aws_s3_bucket_public_access_block.metastore[0]
}

moved {
  from = aws_iam_role.metastore_role
  to   = module.databricks_workspace.aws_iam_role.metastore_role[0]
}

moved {
  from = aws_iam_role_policy.metastore_policy
  to   = module.databricks_workspace.aws_iam_role_policy.metastore_policy[0]
}

moved {
  from = time_sleep.wait_for_uc_role
  to   = module.databricks_workspace.time_sleep.wait_for_uc_role[0]
}

moved {
  from = databricks_metastore.this
  to   = module.databricks_workspace.databricks_metastore.this[0]
}

moved {
  from = databricks_metastore_data_access.this
  to   = module.databricks_workspace.databricks_metastore_data_access.this[0]
}

moved {
  from = databricks_metastore_assignment.this
  to   = module.databricks_workspace.databricks_metastore_assignment.this[0]
}
