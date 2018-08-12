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

module "s3_lambda_code_bucket" {
  source = "../../modules/s3"

  s3_lambda_code_bucket_name = "${join("-", list(var.user, var.project, var.environment, var.s3_lambda_code_bucket_name))}"
  kms_key_alias_arn = "${module.kms.kms_key_alias_arn}"
}

module "iam" {
  source = "../../modules/iam"


  iam_role_name = "${join("-", list(var.user, var.project, var.environment, var.codebuild_iam_role_name))}"
  s3_lambda_code_bucket_arn = "${module.s3_lambda_code_bucket.arn}"
  codebuild_project_name = "${join("-", list(var.user, var.project, var.environment, var.codebuild_project_name))}"
  region = "${var.region}"
  lambda_deploy_function = "${var.lambda_deploy_function}"
}

module "codebuild" {
  source = "../../modules/codebuild"

  region = "${var.region}"
  environment = "${var.environment}"
  codebuild_project_name = "${join("-", list(var.user, var.project, var.environment, var.codebuild_project_name))}"
  codebuild_artifact_name = "${join("-", list(var.user, var.project, var.environment, var.codebuild_artifact_name))}"
  kms_key_alias_arn = "${module.kms.kms_key_alias_arn}"
  iam_role_arn = "${module.iam.iam_role_arn}"
  s3_lambda_code_bucket_arn = "${module.s3_lambda_code_bucket.arn}"
  github_project_url = "${var.github_project_url}"
}

module "codepipeline" {
  source = "../../modules/codepipeline"

  codepipeline_name = "${join("-", list(var.user, var.project, var.environment, var.codepipeline_name))}"
  iam_role_arn = "${module.iam.iam_role_arn}"
  s3_lambda_code_bucket_arn = "${module.s3_lambda_code_bucket.name}"
  codebuild_project_name = "${module.codebuild.name}"
  github_repo = "${var.github_repo}"
  github_owner = "${var.github_owner}"
  github_branch = "${var.github_branch}"
  github_oauth = "${var.github_oauth}"
  lambda_deploy_function = "${var.lambda_deploy_function}"
  environment = "${var.environment}"
  lambda_function = "${var.lambda_function}"
}
