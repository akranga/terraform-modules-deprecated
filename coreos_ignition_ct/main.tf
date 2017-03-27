data "external" "run_ct" {
  program = ["sh" , "${path.module}/script.sh"]

  query = {
    yaml = "${var.yaml}"
  }
}
