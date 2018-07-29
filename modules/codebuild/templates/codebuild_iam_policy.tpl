{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:*:*:log-group:/aws/codebuild/${codebuild_project_name}",
                "arn:aws:logs:*:*:log-group:/aws/codebuild/${codebuild_project_name}:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::codepipeline-${region}-*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "${s3_lambda_code_bucket_name}/*"
            ],
            "Action": [
                "s3:PutObject"
            ]
        }
    ]
}
