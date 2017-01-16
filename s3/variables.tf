variable "name" {}

variable "environment" {
    default = ""
}

variable "acl" {
    default = "private"
}

variable "init_script" {
  type = "string"
  description = "script that will be executed after S3 will be created"
  default = ""
}