# 🚀 IAM Roles Setup for Dev / Test / Prod (Terraform Environments)

## 🏗️ Architecture

IAM User (terraform-user)
→ Assume Roles
→ terraform-dev-role
→ terraform-test-role
→ terraform-prod-role

---

## 📌 Step 1: Create IAM User

aws iam create-user --user-name terraform-user

Attach admin (for setup only):

aws iam attach-user-policy --user-name terraform-user --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

---

## 📌 Step 2: Create Access Keys

aws iam create-access-key --user-name terraform-user

---

## 📌 Step 3: Configure AWS CLI

aws configure --profile base

---

## 📌 Step 4: Trust Policy

Create file: trust-policy.json

{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Principal": {
"AWS": "arn:aws:iam::339712932793:user/terraform-user"
},
"Action": "sts:AssumeRole"
}
]
}

---

## 📌 Step 5: Create Roles

aws iam create-role --role-name terraform-dev-role --assume-role-policy-document file://trust-policy.json

aws iam create-role --role-name terraform-test-role --assume-role-policy-document file://trust-policy.json

aws iam create-role --role-name terraform-prod-role --assume-role-policy-document file://trust-policy.json

---

## 📌 Step 6: Policies

### dev-policy.json

{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": [
"ec2:*",
"elasticloadbalancing:*",
"autoscaling:*",
"rds:*",
"cloudwatch:*"
],
"Resource": "*",
"Condition": {
"StringEquals": {
"aws:ResourceTag/Environment": "dev"
}
}
}
]
}

---

### test-policy.json

{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": [
"ec2:*",
"elasticloadbalancing:*",
"autoscaling:*",
"rds:*",
"cloudwatch:*"
],
"Resource": "*",
"Condition": {
"StringEquals": {
"aws:ResourceTag/Environment": "test"
}
}
}
]
}

---

### prod-policy.json

{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": [
"ec2:Describe*",
"elasticloadbalancing:Describe*",
"autoscaling:Describe*",
"rds:Describe*"
],
"Resource": "*",
"Condition": {
"StringEquals": {
"aws:ResourceTag/Environment": "prod"
}
}
}
]
}

---

## 📌 Step 7: Attach Policies

aws iam put-role-policy --role-name terraform-dev-role --policy-name dev-policy --policy-document file://dev-policy.json

aws iam put-role-policy --role-name terraform-test-role --policy-name test-policy --policy-document file://test-policy.json

aws iam put-role-policy --role-name terraform-prod-role --policy-name prod-policy --policy-document file://prod-policy.json

---

## 📌 Step 8: AWS CLI Role Profiles

Edit ~/.aws/config

[profile dev-role]
role_arn = arn:aws:iam::339712932793:role/terraform-dev-role
source_profile = dev-role
region = us-east-1

[profile test-role]
role_arn = arn:aws:iam::339712932793:role/terraform-test-role
source_profile = test-role
region = us-east-1

[profile prod-role]
role_arn = arn:aws:iam::339712932793:role/terraform-prod-role
source_profile = prod-role
region = us-east-1

---

## 📌 Step 9: Test Roles

aws sts get-caller-identity --profile dev-role
aws sts get-caller-identity --profile test-role
aws sts get-caller-identity --profile prod-role

---

## 📌 Step 10: Switch Role URLs

DEV:
https://signin.aws.amazon.com/switchrole?account=339712932793&roleName=terraform-dev-role

TEST:
https://signin.aws.amazon.com/switchrole?account=339712932793&roleName=terraform-test-role

PROD:
https://signin.aws.amazon.com/switchrole?account=339712932793&roleName=terraform-prod-role

---

## 📌 Step 11: Terraform Provider

provider "aws" {
profile = "dev-role" # or test-role / prod-role
region  = var.aws_region
}

---

## 📌 Step 12: Tagging (MANDATORY)

tags = {
Environment = var.environment
}

dev.tfvars:
environment = "dev"

test.tfvars:
environment = "test"

prod.tfvars:
environment = "prod"

---

## 🎯 Final Result

✔ Dev role → only dev resources
✔ Test role → only test resources
✔ Prod role → restricted access

---
