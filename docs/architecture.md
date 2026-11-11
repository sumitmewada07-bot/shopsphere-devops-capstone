# Architecture Design — ShopSphere

## Overview
ShopSphere is built using a modern, scalable, cloud-native architecture on AWS, separating compute, database, and client-facing layers for high availability and fault tolerance.

## Core Components
1. **Frontend Tier:** Static web assets served via Amazon CloudFront and stored securely in Amazon S3 buckets.
2. **Application Tier:** Containerized Python Flask API deployed primarily on Amazon ECS Fargate (behind an Application Load Balancer) or alternatively within a local Kubernetes cluster via GitOps (Argo CD).
3. **Database Tier:** Amazon RDS PostgreSQL deployed in private subnets, ensuring no direct public internet exposure.
4. **Serverless & Event Processing:** AWS Lambda and Step Functions handling backend event triggers and asynchronous tasks.