variable "name" {}

variable "environment" {
    default = ""
}

variable "acl" {
    default = "public-read"
}

variable "init_script" {
  type = "string"
  description = "script that will be executed after S3 will be created"
  default = ""
}

variable "protocol_schema" {
  type        = "string"
  description = "http or https"
  default     = "http"
}