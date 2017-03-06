output "zone_id" {
  value = "${aws_route53_zone.main.zone_id}"
}

output "domain" {
  value = "${var.name}.${var.r53_domain}"
}

output "name" {
  value = "${var.name}"
}

output "fqdn" {
  value = "${join(".", compact(split(".", "${aws_route53_zone.main.name}")))}"
}