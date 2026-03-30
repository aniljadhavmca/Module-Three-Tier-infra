# ─────────────────────────────
# AWS
# ─────────────────────────────
aws_region = "us-east-1"

# ─────────────────────────────
# Project
# ─────────────────────────────
project_name = "three-tier-dev"

# ─────────────────────────────
# VPC
# ─────────────────────────────
vpc_name = "dev-vpc"
vpc_cidr = "10.10.0.0/16"

public_subnet_1_cidr = "10.10.1.0/24"
public_subnet_2_cidr = "10.10.2.0/24"

private_subnet_1_cidr = "10.10.3.0/24"
private_subnet_2_cidr = "10.10.4.0/24"
private_subnet_3_cidr = "10.10.5.0/24"
private_subnet_4_cidr = "10.10.6.0/24"
private_subnet_5_cidr = "10.10.7.0/24"
private_subnet_6_cidr = "10.10.8.0/24"

availability_zone_1a = "us-east-1a"
availability_zone_1b = "us-east-1b"

allowed_ssh_cidr = ["0.0.0.0/0"]  # dev only

# ─────────────────────────────
# EC2
# ─────────────────────────────
instance_type = "t2.micro"
key_name      = "my-keypair"

# ─────────────────────────────
# RDS
# ─────────────────────────────
db_name     = "bookdb_dev"
db_username = "admin"
db_password = "DevPassword123!"