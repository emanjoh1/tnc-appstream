variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cost_optimization_enabled" {
  description = "True if the Appstream fleet should be shutdown for cost optimization"
  type        = bool
  default     = true
}

variable "max_user_fleet_capacity" {
  description = "The maximum number of admin streaming instances to provision."
  type        = number
  default     = 200
}

variable "min_lrm_stream_instances" {
  description = "The minimum number of LRM stream instances."
  type        = number
  default     = 5
}

variable "aws_account_name" {
  description = "Prefix to be added to resource names."
  type        = string
  default     = "litigationtracker-dev"
}

variable "vpc_id" {
  description = "Id of the VPC to associate with resources."
  type        = string
}

variable "application_subnets" {
  description = "The ids of the subnets to create the Image builder and LRM instances."
  type        = list(any)
  default     = []
}

variable "saml_idp_name" {
  description = "SAML IDP name"
  type        = string
}

variable "saml_metadata_file" {
  description = "Path for the SAML metadata file"
  type        = string
}

variable "tags" {
  description = "Additional tags to be added on top of the default ones."
  type        = map(string)
  default     = {}
}

variable "aws_account_id" {
  description = "The AWS Account ID"
  type        = string
}

variable "user_image_name" {
  description = "The name and version of the AppStream LRM user image."
  type        = string
}

variable "desired_lrm_stream_instances" {
  description = "The number of instances of LRM that are always on."
  type        = number
  default     = 5
}

variable "app_resources_bucket_arn" {
  description = "The ARN for the S3 bucket that stores application and DB resources such as DB backups and LRM installation packages"
  type        = string
}

variable "organizational_unit" {
  description = "OU where the AppStream images should be launched on."
  type        = string
}

variable "db_admin_policy" {
  description = "The policy that allows access to the DB backup bucket and Secrets Manager secret"
  type        = string
}

variable "instance_size" {
  description = "The appstream instance size."
  type        = string
  default     = "stream.standard.xlarge"
}

variable "create_image_builder" {
  description = "True if the image builder should be created for the environment."
  type        = bool
  default     = false
}

variable "tnc_vpcs_cidrs" {
  description = "TNC VPC CIDRs ranges"
  type        = list(any)
  default     = ["172.16.0.0/12", "10.0.0.0/8"]
}

variable "db_security_group" {
  description = "The db security group id to associate with resources."
  type        = string
}

variable "db_port" {
  description = "Default master and replica DB ports."
  type        = number
  default     = 5432
}

variable "aws_vpc_endpoint" {
  description = "VPC endpoint for application resources."
  type        = string
}

variable "aws_vpc_endpoint_streaming" {
  description = "VPC endpoint for streaming resources."
  type        = string
}
