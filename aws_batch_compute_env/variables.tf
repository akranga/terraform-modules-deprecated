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

variable "service_role_access_policy" {
  type = "string"
  description = "describe your variable"
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:CreateOrUpdateTags",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeleteLaunchConfiguration",
      "autoscaling:DescribeAccountLimits",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:PutNotificationConfiguration",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:SuspendProcesses",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
      "ec2:CancelSpotFleetRequests",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSpotFleetInstances",
      "ec2:DescribeSpotFleetRequests",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:ModifySpotFleetRequest",
      "ec2:RequestSpotFleet",
      "ec2:RequestSpotInstances",
      "ec2:TerminateInstances",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecs:CreateCluster",
      "ecs:DeleteCluster",
      "ecs:DeleteCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DeregisterTaskDefinition",
      "ecs:DescribeClusters",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeTaskDefinitions",
      "ecs:DescribeTasks",
      "ecs:DiscoverPollEndpoint",
      "ecs:ListClusters",
      "ecs:ListContainerInstances",
      "ecs:ListTaskDefinitionFamilies",
      "ecs:ListTaskDefinitions",
      "ecs:ListTasks",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:RegisterTaskDefinition",
      "ecs:RunTask",
      "ecs:StartTask",
      "ecs:StartTelemetrySession",
      "ecs:StopTask",
      "ecs:Submit*",
      "ecs:UpdateContainerAgent",
      "iam:GetInstanceProfile",
      "iam:PassRole",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ],
    "Resource": "*"
  }]
}
EOF
}

variable "service_role_trust_policy" {
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
