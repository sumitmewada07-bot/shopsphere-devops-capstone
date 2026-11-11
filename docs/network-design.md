# Network Design — ShopSphere

## VPC & Subnet Topology
The infrastructure is deployed inside a dedicated Amazon VPC spanning multiple Availability Zones (AZs) to ensure high availability and fault tolerance.

* **Public Subnets:** Host the Application Load Balancer (ALB) and NAT Gateways, handling incoming public traffic from internet users via Amazon CloudFront and Route 53.
* **Private Application Subnets:** Host the Amazon ECS Fargate tasks or Kubernetes worker nodes, ensuring no direct public IP addresses are assigned to compute instances.
* **Private Database Subnets:** Host Amazon RDS PostgreSQL instances, completely isolated from direct public routing and accessible only via the application tier security groups.

## Security Groups & Traffic Control
* **ALB Security Group:** Allows inbound HTTP/HTTPS traffic (Ports 80/443) from the public internet.
* **Application Security Group:** Restricts inbound traffic exclusively from the ALB on port 5000 (Flask API).
* **Database Security Group:** Restricts inbound database traffic (Port 5432) exclusively from the Application Security Group, blocking all external connections.