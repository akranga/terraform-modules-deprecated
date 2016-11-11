variable "name" {
  type = "string"
  description = "lambda function name"
}

variable "handler" {
  type = "string"
  description = "handler of lambda function"
  default = "main.handler"
}

variable "runtime" {
  type = "string"
  description = "describe your variable"
  default = "python2.7"
}

variable "timeout" {
  type = "string"
  description = "timeout in seconds"
  default = "60"
}

variable "ram" {
  type = "string"
  description = "container ram"
  default = "128"
}

variable "subnet_ids" {
  type = "list"
  description = "list of subnets for lambda to access vpc resources"
  default = []
}

variable "security_groups" {
  type = "list"
  description = "list of security groups for lambda to access vpc resources"
  default = []
}

variable "zip_file" {
  type = "string"
  description = "zip file with lambda function. If empty then hello world function will be deployed"
  default = ""
}

variable "policy" {
  type = "string"
  description = "Execution policy for lambda"
  default =<<EOF
{
  "Version": "2012-10-17",
  "Statement": [ {
      "Effect": "Allow",
      "Resource": "*",
       "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeTags",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:DescribeAvailabilityZones",
        "ec2:CreateNetworkInterface",
        "ec2:AttachNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeAddresses"
      ]
  },
  {
    "Action": [
        "autoscaling:CompleteLifecycleAction",
        "autoscaling:SuspendProcesses",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLaunchConfigurations"
    ],
    "Resource": "*",
    "Effect": "Allow"
  },
  {
    "Action": [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ],
    "Resource": "*",
    "Effect": "Allow"
  }]
}
EOF
}