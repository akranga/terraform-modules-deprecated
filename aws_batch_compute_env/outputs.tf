output "name" {
  value = "${var.name}"
}

output "service_role_name" {
  value = "${aws_iam_role.service_role.name}"
}

output "service_role_arn" {
  value = "${aws_iam_role.service_role.arn}"
}