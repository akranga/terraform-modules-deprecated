resource "aws_sns_topic" "main" {
  name = "${var.name}"
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
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic"
    ],
    "Resource": "${aws_sns_topic.main.arn}"
  }]
}
POLICY
}

# resource "aws_iam_role_policy" "allow_autoscaling" {
#     name = "${var.name}-allow-autosclaling"
#     role = "${var.role_arn}"
#     policy=<<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [ {
#       "Effect": "Allow",
#       "Resource": "${aws_sns_topic.main.arn}",
#       "Action": [
#         "sns:Publish"
#       ]
#   } ]
# }
# EOF
# }