variable "s3_lambda_code_bucket_name" {}
variable "kms_key_alias_arn" {}

resource "aws_s3_bucket" "s3_lambda_code_bucket" {
  bucket = "${var.s3_lambda_code_bucket_name}"
  acl = "private"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${var.kms_key_alias_arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

output "s3_lambda_code_bucket_arn" { value =  "${aws_s3_bucket.s3_lambda_code_bucket.arn}" }
