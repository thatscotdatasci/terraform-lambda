resource "aws_codepipeline" "codepipeline" {
  name     = "${var.codepipeline_name}"
  role_arn = "${var.iam_role_arn}"

  artifact_store {
    location = "${var.s3_lambda_code_bucket_arn}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceCode"]

      configuration {
        Owner                = "${var.github_owner}"
        Repo                 = "${var.github_repo}"
        Branch               = "${var.github_branch}"
        PollForSourceChanges = "true"
        OAuthToken           = "${var.github_oauth}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceCode"]
      output_artifacts = ["CompiledCode"]
      version         = "1"

      configuration {
        ProjectName = "${var.codebuild_project_name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      input_artifacts = ["CompiledCode"]
      version         = "1"

      configuration {
        FunctionName = "${var.lambda_deploy_function}",
        UserParameters = "{\"function_name\":\"${var.lambda_function}\",\"artifact_name\":\"CompiledCode\",\"alias_name\":\"${var.environment}\"}"
      }
    }
  }
}

output "name" {  value = "${var.codepipeline_name}" }
