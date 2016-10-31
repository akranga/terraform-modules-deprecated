variable "name" {}

variable "assign_public_ip" {
  type = "string"
  description = "Assign public ip for subnet"
  value = "false"
}

variable "domain_name" {
  type = "string"
  description = "domain name associated to vpc instances"
  default = "internal"
}

variable "dns_servers" {
  type = "list"
  description = "Default DNS recursors"
  default = ["10.0.0.2", "8.8.8.8"]
}