variable "user" {}
variable "project" {}
variable "environment" {}

variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-2"
}

variable "create_kms" {
  default = false
}

variable "github_owner" {}
variable "github_repo" {}
variable "github_project_url" {}
variable "github_branch" {}
variable "github_oauth" {}

variable "lambda_deploy_function" {}

variable "lambda_runtime" {}
variable "lambda_handler" {}
