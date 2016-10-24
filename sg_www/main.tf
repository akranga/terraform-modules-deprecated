resource "aws_security_group" "main" {
  name_prefix = "${var.name}"
  description = "Allow inbound www traffic"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["${var.cidr}"]
  }

  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["${var.cidr}"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name}"
  }
}