variable "user" {}
variable "project" {}
variable "environment" {}

variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-2"
}

variable "github_project_url" {}

variable "kms_alias" {}
variable "s3_lambda_code_bucket_name" {}
variable "codebuild_iam_role_name" {}
variable "codebuild_project_name" {}
variable "codebuild_artifact_name" {}
