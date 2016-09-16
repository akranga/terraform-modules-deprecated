output "domain_name" {
	value = "${element( split(":", aws_redshift_cluster.main.endpoint), 0)}"
}

output "endpoint" {
	value = "${aws_redshift_cluster.main.endpoint}"
}

output "jdbc" {
	value = "jdbc:redshift://${aws_redshift_cluster.main.endpoint}/${aws_redshift_cluster.main.database_name}"
}

output "database" {
	value = "${aws_redshift_cluster.main.database_name}"
}

output "user" {
	value = "${aws_redshift_cluster.main.master_username}"
}

output "password" {
	value = "${aws_redshift_cluster.main.master_password}"
}

output "port" {
	value = "${aws_redshift_cluster.main.port}"
}