variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for database"
  type        = string
}
variable "subnet_ids" {
  description = "List of subnet IDs for database"
  type        = list(string)
}