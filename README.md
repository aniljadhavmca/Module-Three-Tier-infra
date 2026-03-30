# 🚀 Terraform Multi-Environment Deployment Guide

This project provisions a **3-tier architecture** across multiple environments using Terraform.

---

## 📁 Environments Setup

We are using **AWS named profiles** for each environment:

* `dev`
* `test`
* `prod`

### 🔧 Configure AWS Profiles

Run the following commands:

```bash
aws configure --profile dev
aws configure --profile test
aws configure --profile prod
```

Verify configured profiles:

```bash
aws configure list-profiles
```

---

## 📂 Environment Directory Structure

Navigate to the respective environment before running Terraform:

```bash
cd root/env/dev    # For Dev
cd root/env/test   # For Test
cd root/env/prod   # For Prod
```

---

## ⚙️ Terraform Apply Flow (Step-by-Step)

Apply modules **one by one in order** to avoid dependency issues:

### 🏗️ Core Infrastructure

```bash
terraform apply -target=module.vpc
terraform apply -target=module.bastion
terraform apply -target=module.frontend-ec2
terraform apply -target=module.backend-ec2
terraform apply -target=module.frontend_alb
terraform apply -target=module.backend_alb
terraform apply -target=module.rds
```

---

## 🔗 Application Deployment Steps

After infrastructure is ready:

1. **Connect to EC2 Instances**

   * Frontend EC2
   * Backend EC2

2. **Backend Configuration**

   * Update `.env` file with:

     * RDS endpoint
     * DB credentials

3. **Frontend Configuration**

   * Update config file with:

     * Backend Load Balancer URL

4. **Deploy Applications**

   * Start backend service
   * Start frontend service

---

## 🔄 Remaining Infrastructure (Auto Scaling Setup)

Once app is verified working, apply remaining modules:

```bash
terraform apply -target=module.frontend_launchtemplate
terraform apply -target=module.backend_launchtemplate
terraform apply -target=module.asg-backend
terraform apply -target=module.asg-frontend
```

---

## 📌 Notes

* Always apply modules **in sequence** to avoid failures.
* Validate each step before proceeding.
* Ensure security groups, ALB health checks, and RDS connectivity are correct.
* Use `terraform plan` before `apply` for safety.

---

## ✅ Recommended Workflow

```bash
terraform init
terraform plan
terraform apply
```

---


*Comment from VEERA*

# Module-Three-Tier apply flow 
```
terraform apply -target=module.vpc
terraform apply -target=module.bastion
terraform apply -target=module.frontend-ec2
terraform apply -target=module.backend-ec2
terraform apply -target=module.frontend_alb
terraform apply -target=module.backend_alb
terraform apply -target=module.rds
```
- now connect to backend and frontend ec2s deploy the application
- in frontend connfig file give backend loadbalncer url
- next backend .env give rds detils 
- next deploy both frontend and backend
# apply reming  mmodules
```
terraform apply -target=module.frontend_launchtemplate
terraform apply -target=module.backend_launchtemplate
terraform apply -target=module.asg-backend
terraform apply -target=module.asg-frontend

```
