variable "user" {}
variable "project" {}
variable "environment" {}

variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-2"
}

variable "kms_alias" {}

variable "s3_lambda_code_bucket_name" {}
