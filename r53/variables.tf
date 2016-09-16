variable "name" {}

variable "r53_zone_id" {}

variable "r53_domain" {}

variable "type" {
	default = "CNAME"
}

variable "records" {
	type = "list"
}

# variable "record" {
# 	default = ""
# }

# variable "record0" {
# 	default = ""
# }

# variable "record1" {
# 	default = ""
# }

# variable "record2" {
# 	default = ""
# }

# variable "record3" {
# 	default = ""
# }

# variable "record4" {
# 	default = ""
# }

# variable "record5" {
# 	default = ""
# }

# variable "record6" {
# 	default = ""
# }

# variable "record7" {
# 	default = ""
# }

# variable "record8" {
# 	default = ""
# }