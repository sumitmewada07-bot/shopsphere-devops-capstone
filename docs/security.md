# Security & Compliance — ShopSphere

## Identity and Access Management (IAM)
* **Principle of Least Privilege:** All IAM roles and policies assigned to ECS tasks, Lambda functions, and EC2 instances are scoped down strictly to required permissions.
* **OIDC Authentication:** GitHub Actions pipelines authenticate securely with AWS using OpenID Connect (OIDC) roles, eliminating the need to store long-lived AWS secret keys in GitHub repository secrets.

## Data Security & Encryption
* **Data at Rest:** All Amazon RDS PostgreSQL instances and Amazon S3 storage buckets are encrypted using AWS KMS managed keys.
* **Data in Transit:** All incoming web and API traffic is encrypted via HTTPS using TLS certificates managed through AWS Certificate Manager (ACM) and enforced by CloudFront and the Application Load Balancer.

## Secret Management
* Database connection strings, API keys, and sensitive configuration parameters are securely stored and retrieved dynamically via AWS Secrets Manager or environment-specific secret injection rather than being hardcoded into application source code.