variable "name" {}

variable "aws_region" {}

variable "stage_name" {
	default = "api"
}

variable "description" {
	default = "API gateway"
}

variable "stage_vars" {
  type = "map"
  description = "API Gateway variables"
  default = {
  }
}