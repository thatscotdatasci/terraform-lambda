terraform {
  backend "s3" {}
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

locals {
  item_suffix = "${join("-", list(var.user, var.project, var.environment))}"
}

module "kms" {
  source = "../../modules/kms"

  create_kms = "${var.create_kms}"
  kms_alias = "${local.item_suffix}"
}

module "s3" {
  source = "../../modules/s3"

  s3_lambda_code_bucket_name = "${local.item_suffix}"
  kms_key_alias_arn = "${module.kms.kms_key_alias_arn}"
}

module "cicd_iam" {
  source = "../../modules/iam"

  file_prefix = "cicd"
  iam_role_name = "${local.item_suffix}-cicd"
  region = "${var.region}"
  s3_lambda_code_bucket_arn = "${module.s3.arn}"
  codebuild_project_name = "${local.item_suffix}"
  lambda_deploy_function = "${var.lambda_deploy_function}"
  lambda_function_name = ""
}

module "lambda_iam" {
  source = "../../modules/iam"

  file_prefix = "${local.item_suffix}"
  iam_role_name = "${local.item_suffix}-lambda"
  region = "${var.region}"
  s3_lambda_code_bucket_arn = ""
  codebuild_project_name = ""
  lambda_deploy_function = ""
  lambda_function_name = "-"
}

module "codebuild" {
  source = "../../modules/codebuild"

  region = "${var.region}"
  environment = "${var.environment}"
  codebuild_project_name = "${local.item_suffix}"
  codebuild_artifact_name = "${local.item_suffix}"
  kms_key_alias_arn = "${module.kms.kms_key_alias_arn}"
  iam_role_arn = "${module.cicd_iam.arn}"
  s3_lambda_code_bucket_arn = "${module.s3.arn}"
  github_project_url = "${var.github_project_url}"
}

module "codepipeline" {
  source = "../../modules/codepipeline"

  codepipeline_name = "${local.item_suffix}"
  iam_role_arn = "${module.cicd_iam.arn}"
  s3_lambda_code_bucket_arn = "${module.s3.name}"
  codebuild_project_name = "${module.codebuild.name}"
  github_repo = "${var.github_repo}"
  github_owner = "${var.github_owner}"
  github_branch = "${var.github_branch}"
  github_oauth = "${var.github_oauth}"
  lambda_deploy_function = "${var.lambda_deploy_function}"
  environment = "${var.environment}"
  lambda_function = "${module.lambda.arn}"
}

module "lambda" {
  source = "../../modules/lambda"

  runtime = "${var.lambda_runtime}"
  function_name = "${local.item_suffix}"
  iam_role_arn = "${module.lambda_iam.arn}"
  handler = "${var.lambda_handler}"
  environment = "${var.environment}"
}
