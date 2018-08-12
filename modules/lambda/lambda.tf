resource "aws_lambda_function" "lambda" {
  filename         = "${path.module}/files/placeholder.zip"
  function_name    = "${var.function_name}"
  role             = "${var.iam_role_arn}"
  handler          = "${var.handler}"
  source_code_hash = "${base64sha256(file("${path.module}/files/placeholder.zip"))}"
  runtime          = "${var.runtime}"
}

resource "aws_lambda_alias" "alias" {
  name             = "${var.environment}"
  function_name    = "${aws_lambda_function.lambda.arn}"
  function_version = "$LATEST"
}

output "arn" { value = "${aws_lambda_function.lambda.arn}" }
