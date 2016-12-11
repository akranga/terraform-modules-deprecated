resource "aws_lambda_function" "main" {
    function_name    = "${var.name}"
    filename         = "${coalesce("${var.zip_file}", "${path.module}/lambda.zip")}"
    runtime          = "${var.runtime}"
    role             = "${aws_iam_role.iam_for_lambda.arn}"
    handler          = "${var.handler}"
    memory_size      = "${var.ram}"
    timeout          = "${var.timeout}"
    publish          = true
    kms_key_arn      = "${var.kms_arn}"
    variables        = "${var.variables}"
    vpc_config {
      subnet_ids         = ["${var.subnet_ids}"]
      security_group_ids = ["${var.security_groups}"]
    }
}

resource "aws_lambda_alias" "latest" {
    name = "latest"
    description = "Alias that points to the lambda latest tag"
    function_name = "${aws_lambda_function.main.arn}"
    function_version = "$LATEST"
}

resource "aws_iam_role" "iam_for_lambda" {
    name_prefix = "invoke-"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"}
    ]
}
EOF
}

resource "aws_iam_role_policy" "lambda" {
    name = "${var.name}-lambda-execution"
    role = "${aws_iam_role.iam_for_lambda.id}"
    policy="${var.policy}"
}