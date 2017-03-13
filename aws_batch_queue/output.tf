
output "arn" {
  value = "arn:aws:batch:${var.region}:${data.aws_caller_identity.current.account_id}:job-queue/${var.name}"
}

output "name" {
  value = "${var.name}"
}
