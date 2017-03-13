variable "name" {
  type = "string"
  description = "name of the batch compute environment"
}

variable "order" {
  type = "string"
  description = "AWS batch queue order"
  default = "1"
}

variable "priority" {
  type = "string"
  description = "AWS batch queue priority"
  default = "1"
}

variable "compute_env" {
  type = "string"
  description = "AWS batch compute environment name"
}

variable "region" {
  type = "string"
  description = "AWS Batch region"
  default = "us-east-1"
}
