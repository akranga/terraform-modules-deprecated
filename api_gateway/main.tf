resource "aws_api_gateway_rest_api" "main" {
  name = "${var.name}"
  description = "${var.description}"
}

resource "aws_api_gateway_method" "root" {
  depends_on  = ["aws_api_gateway_integration.root"] 
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_rest_api.main.root_resource_id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_rest_api.main.root_resource_id}"
  http_method = "${aws_api_gateway_method.root.http_method}"
  type = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_api_key" "main" {
  name = "${var.name}-key"
  description = "API gateway key"

  stage_key {
    rest_api_id = "${aws_api_gateway_rest_api.main.id}"
    stage_name = "${aws_api_gateway_deployment.dev.stage_name}"
  }
}

resource "aws_api_gateway_deployment" "dev" {
  depends_on = ["aws_api_gateway_method.root",       # The REST API doesn't contain any methods
                "aws_api_gateway_integration.root"]  # No integration defined for method 

  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  stage_name  = "${var.stage_name}"
  variables   = "${var.stage_vars}"
}

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
