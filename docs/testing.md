# Testing & Audit Summary — ShopSphere

## Phase 15 Test Cases & Validation
During the validation phase of the ShopSphere capstone, several resilience, self-healing, and security audits were performed to verify infrastructure robustness.

| Test Case / Check | Command / Action Executed | Observed Result | Status |
| :--- | :--- | :--- | :--- |
| **Kubernetes Self-Healing** | `kubectl delete pod` | Deleted pod `1q8f2`; new pod `8jjdr` ready in **17 seconds** | **Passed** ✅ |
| **ECS Deployment Resilience** | ECS Task Deployment | `ResourceInitializationError` triggered ECS Circuit Breaker auto-rollback | **Passed** ✅ |
| **RDS Isolation Audit** | `aws rds describe-db-instances` | `shopsphere-postgres` returned `PubliclyAccessible: False` | **Passed** ✅ |
| **Network Security Audit** | `aws ec2 describe-security-groups` | Inbound traffic strictly constrained to ALB and application security groups | **Passed** ✅ |
| **Cost & Cleanup Audit** | `aws ec2 describe-nat-gateways` | Identified active ECS, RDS, and network components for post-lab teardown | **Passed** ✅ |

## Automated Testing
* **API Unit Tests:** Run locally via pytest inside the `app/api/` directory:
  ```bash
  pytest test_app.py