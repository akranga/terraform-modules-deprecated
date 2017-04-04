resource "aws_s3_bucket" "main" {
    bucket = "${var.name}"

    acl = "${var.acl}"

    force_destroy = true

    versioning {
        enabled = false
    }

    website {
        index_document = "index.html"
        error_document = "error.html"
        redirect_all_requests_to = "http://${var.name}"
    }

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadForGetBucketObjects",
      "Effect":"Allow",
      "Principal": "*",
      "Action":"s3:GetObject",
      "Resource":["arn:aws:s3:::${var.name}/*"
      ]
    }
  ]
}
POLICY

#     cors_rule {
#         allowed_headers = ["*"]
#         allowed_methods = ["GET", "PUT", "POST"]
#         allowed_origins = [ <<EOF
# ${compact(
#     concat(var.cors_origin0, 
#            var.cors_origin1, 
#            var.cors_origin2, 
#            var.cors_origin3, 
#            var.cors_origin4,           
#            var.cors_origin5, 
#            var.cors_origin6, 
#            var.cors_origin7)
#          )}
# EOF
#         ]
#         expose_headers = ["ETag"]
#         max_age_seconds = 3000
#     }

    tags {
        Name = "${var.name}"
        Environment = "${coalesce(var.environment, var.name)}"
    }
}

# resource "aws_s3_bucket_object" "index_document" {
#   bucket       = "${aws_s3_bucket.main.bucket}"
#   key          = "index.html"
#   source       = "${path.module}/index.html"
#   content_type = "text/html"
# }

resource "null_resource" "s3_sync" {
  depends_on = ["aws_s3_bucket.main"]

  provisioner "local-exec" {
    command = "${var.init_script}"
  }
}
