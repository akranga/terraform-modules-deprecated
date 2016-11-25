resource "aws_api_gateway_resource" "main" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.parent_id}"
  path_part   = "${var.resource_part}"
}

resource "aws_api_gateway_method" "main" {
  rest_api_id   = "${var.rest_api_id}"
  resource_id   =  "${aws_api_gateway_resource.main.id}"
  http_method   = "${var.method}"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "main" {
  resource_id             =  "${aws_api_gateway_method.main.id}"
  type                    = "MOCK"
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${aws_api_gateway_resource.main.id}"
  http_method             = "${aws_api_gateway_method.main.http_method}"
}

resource "aws_api_gateway_integration_response" "200" {
  depends_on        = [ "aws_api_gateway_integration.main" ] 
  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${aws_api_gateway_resource.main.id}"
  http_method       = "${var.method}"
  status_code       = "${aws_api_gateway_method_response.200.status_code}"
  selection_pattern = "-"
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.main.id}"
  http_method = "${aws_api_gateway_method.main.http_method}"
  status_code = "200"
}
