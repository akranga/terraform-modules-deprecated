output "subnet_id" {
  value = "${aws_subnet.public.id}"
}

output "security_group_id" {
  value = "${aws_default_security_group.default.id}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}