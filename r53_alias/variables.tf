variable "name" {
  default = ""
}

variable "r53_zone_id" {}

variable "r53_domain" {
  default = ""
}

variable "type" {
	default = "A"
}

variable "alias_name" {}

variable "alias_zone_id" {}