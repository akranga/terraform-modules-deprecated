variable "name" {}

variable "assign_public_ip" {
  type = "string"
  description = "Assign public ip for subnet"
  default = "false"
}

variable "domain_name" {
  type = "string"
  description = "domain name associated to vpc instances"
  default = ""
}

variable "dns_servers" {
  type = "list"
  description = "Default DNS recursors"
  default = ["10.0.0.2", "8.8.8.8"]
}

variable "availability_zone" {
  type = "string"
  description = "Availability zone for default subnet"
  default = ""
}

variable "cidr_block" {
  type = "string"
  description = "describe your variable"
  default = "10.0.0.0/16"
}