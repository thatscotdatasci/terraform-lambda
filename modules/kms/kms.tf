resource "aws_kms_key" "kms_key" {
  count = "${var.create_kms ? 1 : 0}"
}

resource "aws_kms_alias" "kms_alias" {
  count = "${var.create_kms ? 1 : 0}"

  name = "alias/${var.kms_alias}"
  target_key_id = "${aws_kms_key.kms_key.key_id}"

  depends_on = ["aws_kms_key.kms_key"]
}

output "kms_key_alias_arn" {
  value = "${var.create_kms == true ? element(concat(aws_kms_alias.kms_alias.*.arn, list("")), 0) : ""}"
}
