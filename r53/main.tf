resource "aws_route53_record" "main" {
  zone_id = "${var.r53_zone_id}"
  name    = "${var.name}.${var.r53_domain}"
  type    = "${var.type}"
  ttl     = "${var.ttl}"
  records = ["${var.records}"]
}
