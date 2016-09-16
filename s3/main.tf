resource "aws_s3_bucket" "main" {
    bucket = "${var.name}"

    acl = "${var.acl}"

    force_destroy = true

    versioning {
        enabled = false
    }

    tags {
        Name = "${var.name}"
        Environment = "${coalesce(var.environment, var.name)}"
    }

#    logging {
#       target_bucket = "${aws_s3_bucket.log_bucket.id}"
#       target_prefix = "log/"
#    }
}
