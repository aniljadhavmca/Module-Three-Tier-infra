variable "aws_region" {
  description = "AWS Region"
  type        = string
}

# ────────────────
# Project
# ────────────────
variable "project_name" {
  type = string
}

# ────────────────
# VPC
# ────────────────
variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_1_cidr" { type = string }
variable "public_subnet_2_cidr" { type = string }

variable "private_subnet_1_cidr" { type = string }
variable "private_subnet_2_cidr" { type = string }
variable "private_subnet_3_cidr" { type = string }
variable "private_subnet_4_cidr" { type = string }
variable "private_subnet_5_cidr" { type = string }
variable "private_subnet_6_cidr" { type = string }

variable "availability_zone_1a" { type = string }
variable "availability_zone_1b" { type = string }

variable "allowed_ssh_cidr" {
  type = list(string)
}

# ────────────────
# EC2 / Launch Template
# ────────────────
variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

# ────────────────
# RDS
# ────────────────
variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
variable "ami" {
  description = "AMI ID"
  type        = string
}