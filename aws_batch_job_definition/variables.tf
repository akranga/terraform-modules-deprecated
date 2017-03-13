variable "name" {
  type = "string"
  description = "name of the AWS Batch job definition"
}

variable "vcpus" {
  type = "string"
  description = "Spec for number of virtual CPU for job definition"
  default = "1"
}

variable "memory" {
  type = "string"
  description = "Spec for of RAM required to run this job"
  default = "512"
}

variable "parameters" {
  type = "map"
  description = "Job parameters"
  default = {
    provider = ""
  }
}

variable "command" {
  type = "string"
  description = "Command to pass to the container"
}

variable "docker_image" {
  type = "string"
  description = "Docker image that will carry the job execution"
}

variable "role_arn" {
  type = "string"
  description = "IAM role that provides the container in your job with permissions to use the AWS APIs"
}

variable "environment" {
  type = "map"
  default = {}
}

variable "region" {
  type = "string"
  description = "Target region for AWS Batch"
  default = "us-east-1"
}
