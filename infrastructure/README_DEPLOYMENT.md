# webapp-demo - AWS Deployment Guide

## 🚀 Quick Start

This repository contains AWS ECS Fargate infrastructure for deploying webapp-demo.

## 📋 Prerequisites

- AWS Account with appropriate permissions
- Docker installed locally
- Terraform >= 1.0 installed
- AWS CLI configured

## 🔧 Required AWS Permissions

Your AWS user/role needs these permissions:
- ECS (Full access)
- ECR (Full access)
- VPC (Full access)
- IAM (Create roles and policies)
- CloudWatch (Create log groups)
- Application Load Balancer (Full access)

## 🏗️ Infrastructure Overview

- **VPC**: Custom VPC with public/private subnets across 2 AZs
- **ECS Fargate**: Serverless container hosting
- **Application Load Balancer**: Traffic distribution and SSL termination
- **ECR**: Private Docker registry
- **CloudWatch**: Centralized logging

## 📦 Deployment Steps

### 1. Build and Push Docker Image

```bash
# Build the Docker image
docker build -t webapp-demo .

# Tag for ECR (replace ACCOUNT_ID and REGION)
docker tag webapp-demo:latest ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/webapp-demo:latest

# Login to ECR
aws ecr get-login-password --region REGION | docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com

# Push to ECR
docker push ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/webapp-demo:latest
```

### 2. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply infrastructure
terraform apply
```

### 3. Access Your Application

After deployment, get the application URL:

```bash
terraform output application_url
```

## 🔍 Local Development

```bash
# Start with Docker Compose
docker-compose up

# Access locally
curl http://localhost:3000/health
```

## 📊 Monitoring

- **CloudWatch Logs**: `/ecs/webapp-demo`
- **Health Checks**: `/health`
- **Metrics**: ECS service metrics in CloudWatch

## 🛠️ Troubleshooting

### Common Issues

1. **Task fails to start**: Check CloudWatch logs
2. **Health check failures**: Verify `/health` endpoint
3. **Image pull errors**: Ensure ECR permissions and image exists

### Useful Commands

```bash
# Check ECS service status
aws ecs describe-services --cluster webapp-demo --services webapp-demo

# View logs
aws logs tail /ecs/webapp-demo --follow

# Force new deployment
aws ecs update-service --cluster webapp-demo --service webapp-demo --force-new-deployment
```

## 💰 Cost Estimation

- **ECS Fargate**: ~$15-30/month (1 task, 0.5 vCPU, 1GB RAM)
- **Application Load Balancer**: ~$16/month
- **NAT Gateway**: ~$32/month (if using private subnets)
- **Data Transfer**: Variable based on usage

## 🔒 Security Considerations

- ECS tasks run in private subnets
- Security groups restrict access to necessary ports only
- IAM roles follow principle of least privilege
- ECR image scanning enabled

## 🔄 Updates

To update the application:

1. Build and push new Docker image
2. Update ECS service: `aws ecs update-service --cluster webapp-demo --service webapp-demo --force-new-deployment`

## 📞 Support

For issues with this deployment, check:
- CloudWatch logs for application errors
- ECS service events for infrastructure issues
- ALB target group health for connectivity problems
