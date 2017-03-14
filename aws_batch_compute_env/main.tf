
data "template_file" "compute_environment" {
  template = "${file("${path.module}/cli-input.json")}"

  vars {
    name               = "${var.name}"
    instance_types     = "${jsonencode("${var.instance_types}")}"
    subnet_ids         = "${jsonencode("${var.subnet_ids}")}"
    security_group_ids = "${jsonencode("${var.security_group_ids}")}"
    instance_profile   = "${aws_iam_instance_profile.main.arn}"
    spot_fleet_role    = "${aws_iam_role.service_role.arn}"
    service_role       = "${aws_iam_role.service_role.arn}"
    ec2_keypair        = "${var.ec2_keypair}"
    type               = "${var.type}"
    bid_percent        = "${var.bid_percent}"
    min_cpus           = "${var.min_cpus}"
    max_cpus           = "${var.max_cpus}"
    desired_cpus       = "${var.desired_cpus}"
  }
}

data "aws_availability_zone" "vpc" {
  name = "${data.aws_subnet.default.availability_zone}"
}

data "aws_subnet" "default" {
  id = "${var.subnet_ids[0]}"
}

resource "null_resource" "batch" {
  depends_on = ["aws_iam_role_policy_attachment.atta1",
                "aws_iam_role.service_role",
                "aws_iam_policy.service",
                "aws_iam_instance_profile.main"]

  triggers {
    cli_input_json = "${data.template_file.compute_environment.rendered}"
  }

  provisioner "local-exec" {
    command = <<THEEND

mkdir -p ${path.cwd}/.terraform/${var.name}-aws_batch_compute_env
cat <<EOF > ${path.cwd}/.terraform/${var.name}-aws_batch_compute_env/compute-environment.json
${data.template_file.compute_environment.rendered}
EOF

_status=$(aws batch describe-compute-environments \
    --region ${data.aws_availability_zone.vpc.region} \
    --compute-environments "${var.name}" \
    | jq -r '.computeEnvironments[].status')

if [ -z "$$_status" ]; then
  aws batch create-compute-environment \
    --region ${data.aws_availability_zone.vpc.region} \
    --cli-input-json file://${path.cwd}/.terraform/${var.name}-aws_batch_compute_env/compute-environment.json
else
  aws batch update-compute-environment \
    --region ${data.aws_availability_zone.vpc.region} \
    --cli-input-json file://${path.cwd}/.terraform/${var.name}-aws_batch_compute_env/compute-environment.json
fi

for i in {1..60}; do
  _status=$(aws batch describe-compute-environments \
    --region ${data.aws_availability_zone.vpc.region} \
    --compute-environments "${var.name}" \
    | jq -r '.computeEnvironments[].status')
  echo "Waiting for "${var.name}": $_status"
  if [ "$_status" = "VALID" ]; then
    break
  else
    sleep 10
  fi
done

THEEND
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "fail"
    command    = <<THEEND

aws batch update-compute-environment \
  --region ${data.aws_availability_zone.vpc.region} \
  --compute-environment ${var.name} \
  --state DISABLED || true

sleep 10

aws batch delete-compute-environment \
  --region ${data.aws_availability_zone.vpc.region} \
  --compute-environment ${var.name} || true

sleep 10

for i in {1..60}; do
  _status=$(aws batch describe-compute-environments \
    --region ${data.aws_availability_zone.vpc.region} \
    --compute-environments "${var.name}" \
    | jq -r '.computeEnvironments[].status')
  echo "Waiting for "${var.name}": $_status"
  if [ -z "$_status" ]; then
    break
  elif [ "$_status" = "INVALID" ]; then
    echo "Something went wrong with ${var.name} deletion"
    exit 1
  elif [ "$_status" = "VALID" ]; then
    aws batch delete-compute-environment \
      --region ${data.aws_availability_zone.vpc.region} \
      --compute-environment ${var.name} || true
    sleep 10
  else
    sleep 10
  fi
done

THEEND
  }
}


resource "aws_iam_instance_profile" "main" {
    name = "${var.name}-batch-exec"
    roles = ["${aws_iam_role.service_role.name}"]
}

resource "aws_iam_role_policy_attachment" "atta1" {
    role = "${aws_iam_role.service_role.name}"
    policy_arn = "${aws_iam_policy.service.arn}"
}

resource "aws_iam_role" "service_role" {
  name_prefix  = "${var.name}"
  path = "/"
  assume_role_policy = "${var.service_role_policy}"
}

resource "aws_iam_policy" "service" {
  name = "${var.name}-AWSBatchServiceRole"
  description = "Allows batch execution on ${var.name} compute environment"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeImages",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeTags",
        "ec2:DescribeKeyPairs",
        "ec2:DescribeSpotFleetInstances",
        "ec2:DescribeSpotFleetRequests",
        "ec2:DescribeSpotPriceHistory",
        "ec2:RequestSpotFleet",
        "ec2:CancelSpotFleetRequests",
        "ec2:ModifySpotFleetRequest",
        "ec2:TerminateInstances",
        "autoscaling:DescribeAccountLimits",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:CreateLaunchConfiguration",
        "autoscaling:CreateAutoScalingGroup",
        "autoscaling:UpdateAutoScalingGroup",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:DeleteLaunchConfiguration",
        "autoscaling:DeleteAutoScalingGroup",
        "autoscaling:CreateOrUpdateTags",
        "autoscaling:SuspendProcesses",
        "autoscaling:PutNotificationConfiguration",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ecs:DescribeClusters",
        "ecs:DescribeContainerInstances",
        "ecs:DescribeTaskDefinitions",
        "ecs:DescribeTasks",
        "ecs:DeleteCluster",
        "ecs:ListClusters",
        "ecs:ListContainerInstances",
        "ecs:ListTaskDefinitionFamilies",
        "ecs:ListTaskDefinitions",
        "ecs:ListTasks",
        "ecs:CreateCluster",
        "ecs:DeleteCluster",
        "ecs:RegisterTaskDefinition",
        "ecs:DeregisterTaskDefinition",
        "ecs:RunTask",
        "ecs:StartTask",
        "ecs:StopTask",
        "ecs:UpdateContainerAgent",
        "ecs:DeregisterContainerInstance",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "iam:GetInstanceProfile",
        "iam:PassRole"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
