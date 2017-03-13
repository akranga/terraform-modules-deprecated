output "name" {
  value = "${var.name}"
}

output "arn" {
  value = "${file("${path.cwd}/.terraform/${var.name}-aws_batch_job_definition/arn.txt")}"
}
