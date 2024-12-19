variable "vpc_id" {
  description = "Id of the VPC to associate with resources."
  type        = string
}

variable "application_subnets" {
  description = "The ids of the subnets to create the Image builder and LRM instances."
  type        = list(any)
  default     = [] 
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"  
}

variable "streaming_security_group_id" {
  description = "Security group ID for the streaming endpoint."
  type        = string
}
