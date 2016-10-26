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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name}"
  }
}