variable "aws_region" {
  type        = string
  description = "Target AWS Region (GovCloud or Commercial authorized region)"
  default     = "us-gov-west-1"
}

variable "environment" {
  type        = string
  description = "Deployment target environment (dev, test, prod)"
  default     = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for secure isolated VPC"
  default     = "10.100.0.0/16"
}

variable "enable_gpu_cluster" {
  type        = bool
  description = "Dynamic GPU cluster provisioning toggle for cost optimization"
  default     = false
}

variable "gpu_instance_type" {
  type        = string
  description = "GPU instance type for deep learning workloads"
  default     = "g5.xlarge"
}
