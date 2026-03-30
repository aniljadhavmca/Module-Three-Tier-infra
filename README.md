# 🚀 Three-Tier Architecture on AWS using Terraform

This project provisions a **production-style 3-tier architecture** on AWS using Terraform.

---

## 🏗️ Architecture Overview

* **Frontend Tier**

  * Application Load Balancer (ALB)
  * Auto Scaling Group (ASG)
  * Public Subnets

* **Backend Tier**

  * Internal ALB
  * Auto Scaling Group (ASG)
  * Private Subnets

* **Database Tier**

  * Amazon RDS (MySQL)
  * Private DB Subnets

* **Networking**

  * Custom VPC
  * Public + Private Subnets
  * Internet Gateway
  * Security Groups

---

## 📁 Project Structure

```
.
├── modules/
│   ├── infrastructure/        # VPC, Subnets, Security Groups
│   ├── frontend/
│   │   ├── loadbalancer-frontend/
│   │   ├── launch-template/
│   │   └── asg/
│   ├── backend/
│   │   ├── loadbalancer-backend/
│   │   ├── launch-template/
│   │   └── asg/
│   └── database/              # RDS
│
├── envs/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       └── dev.tfvars
```

---

## ⚙️ Prerequisites

* Terraform >= 1.3
* AWS CLI configured
* AWS Account
* EC2 Key Pair (optional)

---

## 🔑 AWS Setup

Configure AWS credentials:

```bash
aws configure
```

---

## 🚀 Deployment Steps

### 1️⃣ Initialize Terraform

```bash
terraform init
```

---

### 2️⃣ Validate Configuration

```bash
terraform validate
```

---

### 3️⃣ Plan Deployment

```bash
terraform plan -var-file="dev.tfvars"
```

---

### 4️⃣ Apply Infrastructure

```bash
terraform apply -var-file="dev.tfvars"
```

---

### 5️⃣ Destroy Infrastructure (when needed)

```bash
terraform destroy -var-file="dev.tfvars"
```

---

## 🔧 Environment Configuration

### dev.tfvars

```
aws_region = "us-east-1"

project_name = "three-tier-dev"

vpc_name = "dev-vpc"
vpc_cidr = "10.10.0.0/16"

instance_type = "t2.micro"
key_name      = "your-keypair-name"

ami = "ami-00ca32bbc84273381"

db_name     = "bookdb_dev"
db_username = "admin"
db_password = "********"
```

---

## ⚠️ Important Notes

### 🔐 Key Pair Issue

If you get:

```
The key pair 'my-keypair' does not exist
```

👉 Fix by:

* Using an existing key pair
* OR creating one:

```bash
aws ec2 create-key-pair \
  --key-name my-keypair \
  --region us-east-1 \
  --query 'KeyMaterial' \
  --output text > my-keypair.pem
```

---

### 🔒 Security Best Practices

* Do NOT commit `.tfvars` files
* Use AWS Secrets Manager for DB passwords
* Restrict SSH access (`0.0.0.0/0` is unsafe)

---

## 📊 Terraform Workflow

```
dev.tfvars → variables.tf → main.tf → modules → AWS resources
```

---

## 💡 Key Concepts Used

* Terraform Modules
* Auto Scaling Groups (ASG)
* Launch Templates
* Application Load Balancer (ALB)
* VPC & Subnet Design
* RDS (MySQL)

---

## 🎯 Future Improvements

* ✅ S3 Remote Backend
* ✅ DynamoDB State Locking
* ✅ CI/CD (GitHub Actions)
* ✅ Multi-Environment (dev/test/prod)
* ✅ Packer AMI pipeline

---

## 👨‍💻 Author

Anil Jadhav

---

## ⭐ If you found this useful, give it a star!
