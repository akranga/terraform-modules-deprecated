output "id" {
	value = "${aws_api_gateway_rest_api.main.id}"
}

output "root_resource_id" {
  value = "${aws_api_gateway_rest_api.main.root_resource_id}"
}

output "stage_name" {
	value = "${aws_api_gateway_deployment.dev.stage_name}"
}

output "endpoint_url" {
	value = "https://${aws_api_gateway_rest_api.main.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_deployment.dev.stage_name}"
}

output "endpoint_host" {
	value = "${aws_api_gateway_rest_api.main.id}.execute-api.${var.aws_region}.amazonaws.com"
}

output "name" {
  value = "${aws_api_gateway_rest_api.main.name}"
}