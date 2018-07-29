variable "kms_alias" {}

resource "aws_kms_key" "kms_key" {}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.kms_alias}"
  target_key_id = "${aws_kms_key.kms_key.key_id}"

  depends_on = ["aws_kms_key.kms_key"]
}

output "kms_key_alias_arn" { value =  "${aws_kms_alias.kms_alias.arn}" }
