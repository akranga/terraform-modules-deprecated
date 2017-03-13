variable "name" {
  type = "string"
  description = "name of the batch compute environment"
}

variable "instance_types" {
  type = "list"
  default = ["m3.medium", "m3.large","c4.large"]
}

variable "subnet_ids" {
  type = "list"
  default = []
}

variable "security_group_ids" {
  type = "list"
  default = ["hello"]
}

variable "min_cpus" {
  type = "string"
  description = "Minimum amount of vCPUs in copute environment autoscaling group"
  default = "0"
}

variable "max_cpus" {
  type = "string"
  description = "Maximum amount of vCPUs in copute environment autoscaling group"
  default = "256"
}

variable "desired_cpus" {
  type = "string"
  description = "Desired capacity of vCPUs in copute environment autoscaling group"
  default = "0"
}

variable "bid_percent" {
  type = "string"
  description = "Bid percentage for spot instances"
  default = "40"
}

variable "ec2_keypair" {
  type = "string"
  description = "keypair name for provisioned environment to connect"
  default = ""
}

variable "type" {
  type = "string"
  description = "SPOT or ON_DEMAND"
  default = "SPOT"
}

variable "service_role_policy" {
  type = "string"
  description = "describe your variable"
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      }
    },
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "batch.amazonaws.com"
      }
    },
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    },
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "spotfleet.amazonaws.com"
      }
    }
  ]
}
EOF
}
