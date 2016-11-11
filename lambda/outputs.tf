output "arn" {
  value = "${aws_lambda_function.main.arn}"
}

output "alias" {
  value = "${aws_lambda_alias.latest.name}"
}

output "version" {
  value = "${aws_lambda_function.main.version}"
}

output "role_arn" {
  value = "${aws_iam_role.iam_for_lambda.arn}"
}

output "name" {
  value = "${aws_lambda_function.main.function_name}"
}