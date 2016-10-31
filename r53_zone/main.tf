resource "aws_route53_zone" "main" {
  name          = "${var.name}.${var.r53_domain}"
  vpc_id        = "${var.vpc_id}"
  force_destroy = true
}

resource "aws_route53_record" "parent" {
  zone_id = "${var.r53_zone_id}"
  name    = "${var.name}"
  type    = "NS"
  ttl     = "${var.ttl}"
  records = ["${aws_route53_zone.main.name_servers}"]
}