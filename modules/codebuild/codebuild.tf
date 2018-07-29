variable "region" {}
variable "environment" {}
variable "s3_lambda_code_bucket_arn" {}
variable "kms_key_alias_arn" {}
variable "codebuild_iam_role_name" {}
variable "codebuild_project_name" {}
variable "codebuild_artifact_name" {}
variable "github_project_url" {}

data "template_file" "codebuild_iam_policy" {
  template = "${file("${path.module}/templates/codebuild_iam_policy.tpl")}"

  vars {
    region = "${var.region}"
    s3_lambda_code_bucket_name = "${var.s3_lambda_code_bucket_arn}"
    codebuild_project_name = "${var.codebuild_project_name}"
  }
}

resource "aws_iam_role" "codebuild_iam_role" {
  name = "${var.codebuild_iam_role_name}"
  assume_role_policy = "${file("${path.module}/files/codebuild_iam_role.json")}"
  force_detach_policies = "True"
}

resource "aws_iam_role_policy" "codebuild_iam_policy" {
  role = "${aws_iam_role.codebuild_iam_role.name}"
  policy = "${data.template_file.codebuild_iam_policy.rendered}"
}

resource "aws_codebuild_project" "codebuild_project" {
  name = "${var.codebuild_project_name}"
  build_timeout = "5"
  service_role = "${aws_iam_role.codebuild_iam_role.arn}"
  badge_enabled = "True"

  artifacts {
    type = "S3"
    location = "${var.s3_lambda_code_bucket_arn}"
    name = "${var.codebuild_artifact_name}.zip"
    path = "${var.codebuild_artifact_name}"
    namespace_type = "BUILD_ID"
    packaging = "ZIP"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/python:3.6.5"
    type = "LINUX_CONTAINER"
  }

  source {
    type = "GITHUB"
    location = "${var.github_project_url}"
    git_clone_depth = 1
    report_build_status = "True"
  }

  tags {
    "Environment" = "${var.environment}"
  }
}
