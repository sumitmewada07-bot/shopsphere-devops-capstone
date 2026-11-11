# shopsphere-devops-capstone


# ShopSphere — Production-Style E-Commerce Platform

ShopSphere is an end-to-end, production-grade DevOps capstone project built on AWS. It demonstrates infrastructure as code (Terraform), container orchestration (ECS Fargate & Kubernetes), automated CI/CD pipelines (GitHub Actions & Argo CD), serverless event processing, and comprehensive observability (CloudWatch, Prometheus, & Grafana).

---

## 🏗️ Architecture Overview

The system provides two deployment models for containerized microservices:
1. **Primary Deployment Path:** AWS ECS Fargate behind an Application Load Balancer (ALB).
2. **Alternative Deployment Path:** Local Kubernetes cluster managed via Argo CD (GitOps).

```text
                        CUSTOMERS
                            |
                     Route 53 / DNS
                            |
                        CloudFront
                       /          \
                 S3 Frontend      API Routing
                                       |
                                  API Gateway
                                       |
                                 Step Functions
                                       |
                                    Lambda
                                       |
                                    Orders

               APPLICATION DEPLOYMENT PATH
               ============================
GitHub --> GitHub Actions --> ECR --> ECS Fargate
                                       |
                                Application ALB
                                       |
                                 RDS PostgreSQL

               ALTERNATIVE DEPLOYMENT PATH
               ===========================
GitHub --> Kubernetes Manifests --> Argo CD
                                       |
                                Kubernetes Cluster
                                       |
                                 ShopSphere API
                                 
                                 
🛠️ Tech Stack & Tools

    Cloud Provider: Amazon Web Services (VPC, EC2, ECS Fargate, RDS PostgreSQL, S3, ECR, CloudFront, Route 53, CloudWatch, Lambda, Step Functions, API Gateway)

    Infrastructure as Code: Terraform

    Configuration Management: Ansible

    Containerization & Orchestration: Docker, Docker Compose, Kubernetes, AWS ECS Fargate

    CI/CD & GitOps: GitHub Actions (OIDC Authentication), Argo CD

    Observability: Prometheus, Grafana, AWS CloudWatch Logs & Metrics

    Backend API: Python (Flask, Gunicorn, Psycopg3)



 📁 Repository Layout

shopsphere-devops-capstone/
├── app/
│   ├── api/            # Flask REST API, Dockerfile, requirements.txt, test_app.py
│   └── frontend/       # Web UI artifacts
├── serverless/
│   └── lambda/         # Order validation Lambda function
├── infra/
│   ├── terraform/      # Infrastructure as Code modules (VPC, ECS, RDS, S3)
│   ├── ansible/        # Linux automation playbooks
│   └── docker/         # Local Docker Compose setup
├── .github/
│   └── workflows/      # CI/CD pipeline (deploy.yml)
├── k8s/
│   ├── api-deployment.yaml
│   ├── api-service.yaml
│   └── argocd/         # GitOps Application configuration
├── monitoring/         # Prometheus & Grafana dashboard configurations
└── docs/               # Architecture, Security, Testing, & Cost documentation


| Test Case / Check | Command / Action Executed | Observed Result | Status |
| :--- | :--- | :--- | :--- |
| **Kubernetes Self-Healing** | `kubectl delete pod` | Deleted pod `1q8f2`; new pod `8jjdr` ready in **17 seconds** | **Passed** ✅ |
| **ECS Deployment Resilience** | ECS Task Deployment | `ResourceInitializationError` triggered ECS Circuit Breaker auto-rollback | **Passed** ✅ |
| **RDS Isolation Audit** | `aws rds describe-db-instances` | `shopsphere-postgres` returned `PubliclyAccessible: False` | **Passed** ✅ |
| **Network Security Audit** | `aws ec2 describe-security-groups` | Inbound traffic strictly constrained to ALB and application security groups | **Passed** ✅ |
| **Cost & Cleanup Audit** | `aws ec2 describe-nat-gateways` | Identified active ECS, RDS, and network components for post-lab teardown | **Passed** ✅ |

🚀 Quick Start & Deployment
1. Local Testing with Docker Compose
Bash

docker compose -f infra/docker/compose.yaml up --build -d
curl http://localhost:5000/health

2. Provision Infrastructure via Terraform
Bash

cd infra/terraform
terraform init
terraform plan
terraform apply

3. Deploy Kubernetes Manifests
Bash

kubectl apply -f k8s/api-deployment.yaml -n shopsphere
kubectl apply -f k8s/api-service.yaml -n shopsphere

🛡️ Security & Compliance Highlights

    Zero Persistent Credentials: GitHub Actions authenticates securely to AWS using IAM OIDC roles.

    Isolated Data Tier: Amazon RDS PostgreSQL is provisioned within private database subnets with no public IP allocation.

    Least Privilege Access: Security groups restrict database ingress exclusively to the application tier on port 5432.