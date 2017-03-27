output "rendered" {
  value = "${lookup("${data.external.run_ct.result}", "rendered", "${var.minimal_ignition}")}"
}
