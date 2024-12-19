variable "saml_idp_name" {
  description = "SAML IDP name"
  type        = string
}

variable "saml_metadata_file" {
  description = "Path for the SAML metadata file"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_name" {
  description = "Prefix to be added to resource names."
  type        = string
  default     = "litigationtracker-dev"
}

variable "tags" {
  description = "Additional tags to be added on top of the default ones."
  type        = map(string)
  default     = {}
}

locals {
  account_id = var.aws_account_name
}
