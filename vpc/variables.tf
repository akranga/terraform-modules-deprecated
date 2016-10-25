variable "name" {}

variable "assign_public_ip" {
  type = "string"
  description = "Assign public ip for subnet"
  value = "false"
}