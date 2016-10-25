variable "release_channel" {
  type = "string"
  description = "CoreOS release channel (default: stable)"
  default = "stable"
}

variable "virtualization_type" {
  type = "string"
  description = "AMI virtualization type (default: hvm)"
  default = "hvm"
}