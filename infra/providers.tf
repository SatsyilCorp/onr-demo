terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment        = var.environment
      ComplianceBaseline = "FedRAMP-High-DoD-IL5"
      ManagedBy          = "Enterprise-Golden-Pipeline"
      DataClassification = "Controlled-Unclassified-Information-CUI"
      CostCenter         = "Analytics-DevSecOps"
    }
  }
}
