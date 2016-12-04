resource "aws_route53_record" "record" {
  zone_id = "${var.r53_zone_id}"
  name    = "${join(".", compact(split(".", "${var.name}.${var.r53_domain}")))}"
  type    = "${var.type}"
  alias {
    name    = "${var.alias_name}"
    zone_id = "${var.alias_zone_id}"
    evaluate_target_health = false
  }
}
