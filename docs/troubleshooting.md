# Troubleshooting Guide — ShopSphere

Common issues encountered during development and deployment, along with their resolutions:

1. **ECS Task Deployment Failure (ResourceInitializationError)**
   * **Symptom:** ECS task fails to start and throws a resource initialization error.
   * **Root Cause:** Subnet configuration issue or missing permissions for the ECS task execution role to pull images from Amazon ECR.
   * **Resolution:** Verified that VPC subnets had proper route tables pointing to a NAT Gateway and updated the ECS execution role IAM policy with `AmazonEC2ContainerRegistryReadOnly`.

2. **Database Connection Timeout**
   * **Symptom:** Flask application API returns 500 internal server error when trying to connect to PostgreSQL.
   * **Root Cause:** Security group rules blocking port 5432 between the application tier and the RDS instance.
   * **Resolution:** Updated the RDS security group inbound rules to explicitly allow traffic on port 5432 exclusively from the Application Security Group.

3. **Kubernetes Pod CrashLoopBackOff**
   * **Symptom:** `kubectl get pods` shows pods repeatedly crashing and restarting.
   * **Root Cause:** Missing environment variables for database credentials in the deployment manifest.
   * **Resolution:** Created a Kubernetes Secret containing the database URI and injected it securely into the pod deployment configuration.

4. **GitHub Actions OIDC Authentication Error**
   * **Symptom:** CI/CD workflow fails at the AWS assume-role step with access denied.
   * **Root Cause:** Trust policy mismatch between the GitHub repository subject claim and the IAM role configuration.
   * **Resolution:** Updated the IAM role trust policy to match the correct GitHub organization, repository name, and branch reference (`main`).

5. **Local Docker Compose Port Conflict**
   * **Symptom:** `docker compose up` fails because port 5000 is already in use on the host machine.
   * **Root Cause:** Another local service or AirPlay receiver running on macOS/Linux occupying port 5000.
   * **Resolution:** Stopped the conflicting local process or modified the port mapping in `compose.yaml` to use an alternative port (e.g., `5001:5000`).