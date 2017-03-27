variable "yaml" {
  type = "string"
}

variable "platform" {
  type = "string"
  default = "ec2"
}

variable "minimal_ignition" {
  type = "string"
  description = "describe your variable"
  default = <<EOF
{\"ignition\":{\"version\":\"2.0.0\",\"config\":{}},\"storage\":{},\"systemd\":{},\"networkd\":{},\"passwd\":{}}
EOF
}
