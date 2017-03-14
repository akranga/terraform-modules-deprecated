resource "aws_vpc" "main" {
    cidr_block = "${var.cidr_block}"

    enable_dns_support = true
    enable_dns_hostnames = true

    tags {
        Name = "${var.name}"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "${var.name}"
    }
}

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.main.id}"
    map_public_ip_on_launch = "${var.assign_public_ip}"
    availability_zone = "${var.availability_zone}"
    cidr_block        = "${cidrsubnet(aws_vpc.main.cidr_block, 4, 1)}"
    tags {
        Name = "${var.name}"
    }
}

resource "aws_route_table" "r" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
    }

    tags {
        Name = "${var.name}"
    }
}

resource "aws_main_route_table_association" "a" {
    vpc_id = "${aws_vpc.main.id}"
    route_table_id = "${aws_route_table.r.id}"
}

# resource "aws_vpc_dhcp_options_association" "dns_resolver" {
#     vpc_id = "${aws_vpc.main.id}"
#     dhcp_options_id = "${aws_vpc_dhcp_options.main.id}"
# }

# resource "aws_vpc_dhcp_options" "main" {
#     domain_name = "${var.domain_name}"
#     domain_name_servers = ["${var.dns_servers}"]
#     ntp_servers = ["127.0.0.1"]
#     netbios_name_servers = ["127.0.0.1"]
#     netbios_node_type = 2

#     tags {
#         Name = "${var.name}"
#     }
# }

resource "aws_default_security_group" "default" {
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "default-${var.name}"
  }
}