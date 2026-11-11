# Cost Estimate & Teardown Plan — ShopSphere

## Estimated Monthly AWS Spend (Development / Sandbox Scale)
Operating ShopSphere on AWS using low-tier resources for testing and demonstration involves the following estimated monthly expenditures:

| AWS Service | Resource Type / Configuration | Estimated Monthly Cost (USD) |
| :--- | :--- | :--- |
| **Amazon RDS** | `db.t3.micro` (PostgreSQL, Single-AZ, 20GB gp2) | ~$15.00 |
| **Amazon ECS Fargate** | 0.25 vCPU, 0.5GB RAM (Running 24/7) | ~$9.00 |
| **NAT Gateway** | 1 NAT Gateway + Data Processing | ~$35.00 |
| **Application Load Balancer** | ALB hours + LCU usage | ~$22.00 |
| **S3 & CloudFront** | Storage and standard data transfer | ~$2.00 |
| **Total Estimated Spend** | | **~$83.00 / month** |

## Cost Optimization & Post-Lab Teardown Plan
To prevent unexpected AWS charges after completing the capstone project or evaluation, the following teardown procedure is executed:

1. **Destroy Terraform Infrastructure:**
   Run the following command inside the Terraform directory to automatically delete all provisioned AWS resources (VPC, ECS cluster, RDS database, ALB, and NAT gateways):
   ```bash
   cd infra/terraform
   terraform destroy

    Verify Deletion via AWS CLI:
    Ensure no lingering resources (such as unattached Elastic IPs, active NAT gateways, or RDS snapshots) remain:
    Bash

    aws ec2 describe-nat-gateways
    aws rds describe-db-instances