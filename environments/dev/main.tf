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

  kms_alias = "${join("-", list(var.user, var.project, var.environment, var.kms_alias))}"
}

module "s3" {
  source = "../../modules/s3"

  s3_lambda_code_bucket_name = "${join("-", list(var.user, var.project, var.environment, var.s3_lambda_code_bucket_name))}"
  kms_key_alias_arn = "${module.kms.kms_key_alias_arn}}"
}
