variable "name" {
  type = "string"
  description = "Name of the hosted zone and subdomain"
  default = "default_value"
}

variable "r53_domain" {
  type = "string"
  description = "Domain name of the parent hosted zone"
}

variable "r53_zone_id" {
  type = "string"
  description = "Parent domain name of the parent hosted zone"
}

variable "ttl" {
  type = "string"
  description = "TTL for NS record that corresponds to the new hosted zone"
  default = "30"
}

variable "vpc_id" {
  type = "string"
  description = "VPC ID if you want to manage hosts with r53"
  default = ""
}