terraform {
  backend "s3" {}
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "kms" {
  source = "../../modules/kms"

  create_kms = "${var.create_kms}"
  kms_alias = "${join("-", list(var.user, var.project, var.environment, var.kms_alias))}"
}

module "s3" {
  source = "../../modules/s3"

  s3_lambda_code_bucket_name = "${join("-", list(var.user, var.project, var.environment, var.s3_lambda_code_bucket_name))}"
  kms_key_alias_arn = "${module.kms.kms_key_alias_arn}"
}

module "codebuild" {
  source = "../../modules/codebuild"

  region = "${var.region}"
  environment = "${var.environment}"
  codebuild_project_name = "${join("-", list(var.user, var.project, var.environment, var.codebuild_project_name))}"
  codebuild_artifact_name = "${join("-", list(var.user, var.project, var.environment, var.codebuild_artifact_name))}"
  kms_key_alias_arn = "${module.kms.kms_key_alias_arn}"
  codebuild_iam_role_name = "${join("-", list(var.user, var.project, var.environment, var.codebuild_iam_role_name))}"
  s3_lambda_code_bucket_arn = "${module.s3.s3_lambda_code_bucket_arn}"
  github_project_url = "${var.github_project_url}"
}
