# S3 Artifacts Bucket Resources
resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project_name}-${var.environment}-unique-artifact-bucket"
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Networking Module Call
module "networking" {
  source = "./modules/networking"

  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  environment  = var.environment
}

# Security Module Call
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
}

# Compute Module Call
module "compute" {
  source = "./modules/compute"

  project_name = var.project_name
  environment  = var.environment
}

# Database Module Call
module "database" {
  source = "./modules/database"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.networking.vpc_id
  security_group_id = module.security.security_group_id
  subnet_ids        = module.networking.public_subnet_ids
}

# Monitoring Module Call
module "monitoring" {
  source = "./modules/monitoring"

  project_name = var.project_name
  environment  = var.environment
}