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

resource "null_resource" "s3_sync" {
  depends_on = ["aws_s3_bucket.main"]

  provisioner "local-exec" {
    command = "${var.init_script}"
  }
}
