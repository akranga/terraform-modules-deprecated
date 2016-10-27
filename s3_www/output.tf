output "bucket" {
  value = "${aws_s3_bucket.main.id}"
}

output "website_domain" {
  value = "${aws_s3_bucket.main.website_domain}"
}

output "website_endpoint" {
  value = "${aws_s3_bucket.main.website_endpoint}"
}

output "hosted_zone_id" {
  value = "${aws_s3_bucket.main.hosted_zone_id}"
}