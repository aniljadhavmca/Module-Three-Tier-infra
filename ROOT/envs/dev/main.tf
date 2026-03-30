provider "aws" {
  region = var.aws_region
}

# ─────────────────────────────
# VPC
# ─────────────────────────────
module "vpc" {
  source = "../../modules/infrastructure"

  aws_region = var.aws_region
  vpc_name   = var.vpc_name
  vpc_cidr   = var.vpc_cidr

  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr

  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  private_subnet_3_cidr = var.private_subnet_3_cidr
  private_subnet_4_cidr = var.private_subnet_4_cidr
  private_subnet_5_cidr = var.private_subnet_5_cidr
  private_subnet_6_cidr = var.private_subnet_6_cidr

  availability_zone_1a = var.availability_zone_1a
  availability_zone_1b = var.availability_zone_1b

  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# ─────────────────────────────
# Frontend ALB
# ─────────────────────────────
module "frontend_alb" {
  source = "../../modules/frontend/loadbalancer-frontend"

  aws_region = var.aws_region
  vpc_id     = module.vpc.vpc_id
  subnets    = module.vpc.public_subnets

  security_group_id = module.vpc.alb_frontend_sg_id
  alb_name          = "${var.project_name}-frontend-alb"
  target_group_name = "${var.project_name}-frontend-tg"
}

# ─────────────────────────────
# Backend ALB
# ─────────────────────────────
module "backend_alb" {
  source = "../../modules/backend/loadbalancer-backend"

  aws_region = var.aws_region
  vpc_id     = module.vpc.vpc_id
  subnets    = module.vpc.public_subnets

  security_group_id = module.vpc.alb_backend_sg_id
  alb_name          = "${var.project_name}-backend-alb"
  target_group_name = "${var.project_name}-backend-tg"
}

# ─────────────────────────────
# RDS
# ─────────────────────────────
module "rds" {
  source = "../../modules/database"

  aws_region   = var.aws_region
  project_name = var.project_name

  identifier        = "${var.project_name}-rds"
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  db_subnet_1_id = module.vpc.private_db_subnets[0]
  db_subnet_2_id = module.vpc.private_db_subnets[1]

  rds_sg_id = module.vpc.database_sg_id
}

# ─────────────────────────────
# Frontend Launch Template
# ─────────────────────────────
module "frontend_launchtemplate" {
  source = "../../modules/frontend/launch-template"

  aws_region   = var.aws_region
  project_name = var.project_name

  instance_type  = var.instance_type
  frontend_sg_id = module.vpc.frontend_server_sg_id
  key_name       = var.key_name

  ami = var.ami   # ✅ ADD THIS ALSO
}

# ─────────────────────────────
# Backend Launch Template
# ─────────────────────────────
module "backend_launchtemplate" {
  source = "../../modules/backend/launch-template"

  aws_region   = var.aws_region
  project_name = var.project_name

  instance_type = var.instance_type
  backend_sg_id = module.vpc.backend_server_sg_id
  key_name      = var.key_name

  ami = var.ami   # ✅ THIS LINE WAS MISSING
}

# ─────────────────────────────
# ASG - Backend
# ─────────────────────────────
module "asg_backend" {
  source = "../../modules/backend/asg"

  aws_region   = var.aws_region
  project_name = var.project_name

  backend_launch_template_id = module.backend_launchtemplate.backend_launch_template_id

  app_subnet_1_id = module.vpc.private_app_subnets[0]
  app_subnet_2_id = module.vpc.private_app_subnets[1]

  backend_target_group_arn = module.backend_alb.alb_target_group_arn

  backend_desired_capacity = 1
  backend_min_size         = 1
  backend_max_size         = 2
}

# ─────────────────────────────
# ASG - Frontend
# ─────────────────────────────
module "asg_frontend" {
  source = "../../modules/frontend/asg"

  aws_region   = var.aws_region
  project_name = var.project_name

  frontend_launch_template_id = module.frontend_launchtemplate.frontend_launch_template_id

  web_subnet_1_id = module.vpc.public_subnets[0]
  web_subnet_2_id = module.vpc.public_subnets[1]

  frontend_target_group_arn = module.frontend_alb.alb_target_group_arn

  frontend_desired_capacity = 1
  frontend_min_size         = 1
  frontend_max_size         = 2
}