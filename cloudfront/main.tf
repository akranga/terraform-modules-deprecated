resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = "${var.s3_origin}.s3.amazonaws.com"
    origin_id   = "S3-${var.s3_origin}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path}"
    }

    # custom_origin_config {
    #   http_port = "80"
    #   https_port = "443"
    #   origin_protocol_policy = "match-viewer"
    #   origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    # }
  }

  enabled             = true
  comment             = "${var.s3_origin}"
  default_root_object = "index.html"
  # price_class = "PriceClass_200"
  price_class = "PriceClass_All"

  # logging_config {
  #   include_cookies = false
  #   bucket          = "${var.s3_logging}"
  #   prefix          = "/log/${var.s3_origin}"
  # }

  aliases = ["${var.domain_names}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.s3_origin}"
    compress         = true
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      # locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "main" {
  comment = "${var.s3_origin}"
}