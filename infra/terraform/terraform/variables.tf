variable "aws_region" {
  description = "AWS Region for ShopSphere"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "shopsphere"
}

variable "vpc_cidr" {
  description = "VPC address range"
  type        = string
  default     = "10.20.0.0/16"
}
