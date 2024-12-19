variable "tnc_vpcs_cidrs" {
  description = "TNC VPC CIDRS ranges"
  type        = list(any)
  default     = ["172.16.0.0/12", "10.0.0.0/8"]  
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

variable "db_security_group" {
  description = "The db security group id to associate with lambda function security group."
  type        = string
}

variable "db_port" {
  description = "Default master and replica DB ports."
  type        = number
  default     = 5432 
}

variable "vpc_id" {
  description = "Id of the VPC to associate the lambda function."
  type        = string
}
