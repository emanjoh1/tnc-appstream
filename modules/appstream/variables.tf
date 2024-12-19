variable "aws_account_name" {
  description = "Prefix to be added to resource names."
  type        = string
}

variable "tags" {
  description = "Additional tags to be added on top of the default ones."
  type        = map(string)
}

variable "desired_lrm_stream_instances" {
  description = "The number of instances of LRM that are always on."
  type        = number
}

variable "organizational_unit" {
  description = "OU where the AppStream images should be launched on."
  type        = string
}

variable "create_image_builder" {
  description = "True if the image builder should be created for the environment."
  type        = bool
  default     = false
}

variable "app_resources_bucket_arn" {
  description = "The ARN for the S3 bucket that stores application and DB resources such as DB backups and LRM installation packages."
  type        = string
}

variable "db_admin_policy" {
  description = "The policy that allows access to the DB backup bucket and Secrets Manager secret."
  type        = string
}

variable "user_image_name" {
  description = "The name and version of the AppStream LRM user image."
  type        = string
}

variable "instance_size" {
  description = "The AppStream instance size."
  type        = string
  default     = "stream.standard.xlarge"
}

variable "application_subnets" {
  description = "The ids of the subnets to create the Image builder and LRM instances."
  type        = list(any)
  default     = []
}

variable "security_groups" {
  description = "Security group IDs for the AppStream resources."
  type        = any
}

variable "aws_vpc_endpoint" {
  description = "The VPC endpoint ID for AppStream resources."
  type        = string
}

variable "aws_vpc_endpoint_streaming" {
  description = "The VPC endpoint ID for AppStream streaming."
  type        = string
}

variable "aws_security_group" {
  description = "Security group IDs for the AppStream resources."
  type = object({
    appstream = string
  })
}
