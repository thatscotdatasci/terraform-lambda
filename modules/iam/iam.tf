data "template_file" "iam_policy" {
  template = "${file("${path.module}/templates/iam_policy.tpl")}"

  vars {
    region = "${var.region}"
    s3_lambda_code_bucket_name = "${var.s3_lambda_code_bucket_arn}"
    codebuild_project_name = "${var.codebuild_project_name}"
    lambda_deploy_function = "${var.lambda_deploy_function}"
  }
}

resource "aws_iam_role" "iam_role" {
  name = "${var.iam_role_name}"
  assume_role_policy = "${file("${path.module}/files/iam_role.json")}"
  force_detach_policies = "True"
}

resource "aws_iam_role_policy" "iam_policy" {
  role = "${aws_iam_role.iam_role.name}"
  policy = "${data.template_file.iam_policy.rendered}"
}

output "iam_role_arn" { value =  "${aws_iam_role.iam_role.arn}" }
