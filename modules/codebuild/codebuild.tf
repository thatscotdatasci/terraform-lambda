resource "aws_codebuild_project" "codebuild_project" {
  name = "${var.codebuild_project_name}"
  build_timeout = "5"
  service_role = "${var.iam_role_arn}"
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

output "name" {  value = "${var.codebuild_project_name}" }
