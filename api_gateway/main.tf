resource "aws_api_gateway_rest_api" "main" {
  name = "${var.name}"
  description = "${var.description}"
}

resource "aws_api_gateway_method" "root" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_rest_api.main.root_resource_id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root" {
  depends_on  = ["aws_api_gateway_method.root"] 
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_rest_api.main.root_resource_id}"
  http_method = "${aws_api_gateway_method.root.http_method}"
  type = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_account" "logging" {
  cloudwatch_role_arn = "${aws_iam_role.cloudwatch.arn}"
}

resource "aws_iam_role" "cloudwatch" {
    name = "${var.name}-cloudwatch"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
    name = "${uuid()}"
    role = "${aws_iam_role.cloudwatch.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# resource "aws_api_gateway_api_key" "main" {
#   name = "${var.name}-key"
#   description = "API gateway key"

#   stage_key {
#     rest_api_id = "${aws_api_gateway_rest_api.main.id}"
#     stage_name = "${aws_api_gateway_deployment.dev.stage_name}"
#   }
# }

# resource "aws_api_gateway_deployment" "dev" {
#   depends_on = ["aws_api_gateway_method.root",       # The REST API doesn't contain any methods
#                 "aws_api_gateway_integration.root"]  # No integration defined for method 

#   rest_api_id = "${aws_api_gateway_rest_api.main.id}"
#   stage_name  = "${var.stage_name}"
#   variables   = "${var.stage_vars}"
# }

resource "aws_api_gateway_integration_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_rest_api.main.root_resource_id}"
  http_method = "${aws_api_gateway_method.root.http_method}"
  status_code = "${aws_api_gateway_method_response.200.status_code}"
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_rest_api.main.root_resource_id}"
  http_method = "${aws_api_gateway_method.root.http_method}"
  status_code = "200"
}

#resource "aws_api_gateway_method" "dev" {
#  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
#  resource_id = "${aws_api_gateway_resource.dev.id}"
#  http_method = "GET"
#  authorization = "NONE"
#}
