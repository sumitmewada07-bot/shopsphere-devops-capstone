# Monitoring & Observability — ShopSphere

This directory contains configuration files and dashboards for tracking the operational health, metrics, and logs of the ShopSphere application stack.

## Folder Structure & Components
* **`prometheus/`**
  * `prometheus.yml`: Scrape configuration for collecting metrics from the ShopSphere API and underlying containers.
* **`grafana/`**
  * `dashboard.json`: Pre-built Grafana dashboard layout for visualizing HTTP request rates, latency, and CPU/memory utilization.
* **`cloudwatch/`**
  * `logs-config.md`: Documentation for AWS CloudWatch log groups, container insights, and automated alarm thresholds for ECS/EC2 instances.

## Key Metrics Monitored
1. **API Performance:** Request throughput (`rate(flask_http_request_total)`) and error rates (HTTP 5xx/4xx).
2. **Infrastructure Health:** CPU and memory utilization across ECS Fargate tasks and EC2 instances.
3. **Database Metrics:** PostgreSQL connection counts and query latency.