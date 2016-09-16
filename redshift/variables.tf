variable "name" {}

variable "database" {}

variable "port" {
	default = "5439"
}

variable "user" {
	default = "root"
}

variable "password" {}

variable "snapshot_id" {}

variable "snapshot_cluster_id" {}

variable "cluster_type" {
	default = "single-node"
}

variable "compute_nodes" {
	default = "1"
}

variable "node_type" {
	default = "dc1.large"
}

variable "subnet_ids" {
	type = "list"
	default = []
}

variable "security_groups" {
	type = "list"
	default = []
}