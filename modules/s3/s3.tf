resource "aws_s3_bucket" "s3_lambda_code_bucket" {
  bucket = "${var.s3_lambda_code_bucket_name}"
  acl = "private"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${var.kms_key_alias_arn}"
        sse_algorithm     = "${var.kms_key_alias_arn == "" ? "AES256" : "aws:kms"}"
      }
    }
  }
}

output "name" { value =  "${aws_s3_bucket.s3_lambda_code_bucket.id}" }
output "arn" { value =  "${aws_s3_bucket.s3_lambda_code_bucket.arn}" }
