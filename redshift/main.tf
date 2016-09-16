resource "aws_redshift_cluster" "main" {
  cluster_identifier = "${var.name}"
  database_name = "${var.database}"
  port = "${var.port}"
  master_username = "${var.user}"
  master_password = "${var.password}"
  node_type = "${var.node_type}"
  cluster_type = "${var.cluster_type}"
  number_of_nodes = "${var.compute_nodes}"
  vpc_security_group_ids = ["${var.security_groups}"]
  cluster_subnet_group_name = "${aws_redshift_subnet_group.main.name}"
  cluster_parameter_group_name  = "${aws_redshift_parameter_group.main.name}"
}

resource "aws_redshift_subnet_group" "main" {
    name = "${var.name}"
    description = "'${var.name}' Redshift cluster main subnet group"
    subnet_ids = ["${var.subnet_ids}"]
}

resource "aws_redshift_parameter_group" "main" {
    name = "${var.name}"
    family = "redshift-1.0"
    description = "'${var.name}' Redshift cluster main parameter group"

#    parameter {
#      name = "require_ssl"
#      value = "true"
#    }

    parameter{
      name = "enable_user_activity_logging"
      value = "true"
    }
}