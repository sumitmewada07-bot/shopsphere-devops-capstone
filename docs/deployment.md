# Deployment Guide — ShopSphere

## Prerequisites & Toolchain
* Terraform (v1.5+)
* Docker & Docker Compose
* AWS CLI configured with appropriate credentials
* kubectl and Helm (for Kubernetes & Argo CD deployment)

## 1. Infrastructure Provisioning (Terraform)
Navigate to the Terraform directory and apply the configuration to set up the VPC, subnets, ECS cluster, and RDS database:
```bash
cd infra/terraform
terraform init
terraform plan
terraform apply

2. Local Container Deployment (Docker Compose)

To run the complete application stack locally for testing and debugging:
Bash

docker compose -f infra/docker/compose.yaml up --build -d

3. CI/CD Pipeline Deployment (GitHub Actions)

    Code pushed to the main branch triggers the GitHub Actions workflow (.github/workflows/deploy.yml).

    The pipeline authenticates via IAM OIDC, builds the Docker image, pushes it to Amazon ECR, and updates the Amazon ECS task definition to deploy the latest version automatically.

4. GitOps Deployment (Kubernetes & Argo CD)

Alternatively, to deploy using Kubernetes manifests managed by Argo CD:
Bash

kubectl apply -f k8s/api-deployment.yaml -n shopsphere
kubectl apply -f k8s/api-service.yaml -n shopsphere


---
