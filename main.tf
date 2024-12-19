####################################
# Root Module
####################################

provider "aws" {
  region = var.aws_region
}

module "autoscaling" {
  source = "./modules/autoscaling"

  max_user_fleet_capacity   = var.max_user_fleet_capacity
  min_lrm_stream_instances  = var.min_lrm_stream_instances
  cost_optimization_enabled = var.cost_optimization_enabled
  aws_account_name          = var.aws_account_name
  user_fleet                = module.appstream.user_fleet
}

module "vpc" {
  source = "./modules/vpc"

  vpc_id                      = var.vpc_id
  aws_region                  = var.aws_region
  application_subnets         = var.application_subnets
  streaming_security_group_id = module.security_groups.streaming_sg_id
}

module "iam" {
  source = "./modules/iam"

  saml_idp_name      = var.saml_idp_name
  saml_metadata_file = var.saml_metadata_file
  aws_region         = var.aws_region
  aws_account_name   = var.aws_account_name
  tags               = var.tags
}

module "appstream" {
  source = "./modules/appstream"

  security_groups              = module.security_groups
  aws_vpc_endpoint             = var.aws_vpc_endpoint
  aws_vpc_endpoint_streaming   = var.aws_vpc_endpoint_streaming
  aws_account_name             = var.aws_account_name
  create_image_builder         = var.create_image_builder
  desired_lrm_stream_instances = var.desired_lrm_stream_instances
  application_subnets          = var.application_subnets
  instance_size                = var.instance_size
  user_image_name              = var.user_image_name
  organizational_unit          = var.organizational_unit
  tags                         = var.tags
  db_admin_policy              = var.db_admin_policy
  app_resources_bucket_arn     = var.app_resources_bucket_arn

  aws_security_group = {
    appstream = module.security_groups.appstream_sg_id
  }
}

module "security_groups" {
  source = "./modules/security_groups"

  aws_account_name  = var.aws_account_name
  vpc_id            = var.vpc_id
  db_security_group = var.db_security_group
  db_port           = var.db_port
  tnc_vpcs_cidrs    = var.tnc_vpcs_cidrs
  tags              = var.tags
}
