variable "vpc_id" {
  type = "string"
  description = "ID of the VPC that will own the Security Group"
}

variable "cidr" {
  type = "string"
  description = "CIDR that corresponds to ingress traffic"
  default = "0.0.0.0/0"
}

variable "tags" {
  type = "map"
  description = "tags for Security group"
  default = {
  }
}

variable "prefix" {
  type = "string"
  description = "security group name prefix"
}