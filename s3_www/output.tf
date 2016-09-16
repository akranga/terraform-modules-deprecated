output "bucket" {
  value = "${aws_s3_bucket.main.id}"
}

output "website_domain" {
  value = "${aws_s3_bucket.main.website_domain}"
}

output "hosted_zone_id" {
  value = "${aws_s3_bucket.main.hosted_zone_id}"
}