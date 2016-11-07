resource "aws_sns_topic" "main" {
  name = "${var.name}"
}

resource "aws_cloudwatch_log_group" "main" {
  name = "${var.name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "main" {
  name           = "${var.name}"
  log_group_name = "${aws_cloudwatch_log_group.main.name}"
}

resource "aws_sns_topic_subscription" "subs" {
    topic_arn = "${aws_sns_topic.main.arn}"
    protocol  = "application"
    endpoint  = "${aws_cloudwatch_log_group.main.name}"
    endpoint_auto_confirms = true
}

resource "aws_sns_topic_policy" "custom" {
  arn = "${aws_sns_topic.main.arn}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement":[{
    "Sid": "default",
    "Effect": "Allow",
    "Principal": {"AWS":"*"},
    "Action": [
      "SNS:Publish",
      "SNS:GetTopicAttributes",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ],
    "Resource": "${aws_sns_topic.main.arn}"
  }]
}
POLICY
}