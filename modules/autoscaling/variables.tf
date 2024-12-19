variable "aws_account_name" {
  description = "Prefix to be added to resource names."
  type        = string
}

variable "max_user_fleet_capacity" {
  description = "The maximum number of admin streaming instances to provision."
  type        = number
}

variable "min_lrm_stream_instances" {
  description = "The minimum number of instances of LRM that are always on."
  type        = number
}

variable "cost_optimization_enabled" {
  description = "True if the AppStream fleet should be shutdown for cost optimization"
  type        = bool
  default     = true
}

variable "user_fleet" {
  description = "Reference to the user fleet resource"
  type        = any
}
