resource aws_iam_role_policy_attachment ec2_ssm_attachment {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = data.aws_iam_policy.ec2_ssm_policy.arn
}


resource aws_iam_policy lambda_send_command_to_ssm_policy {
  name        = "lambda_send_command_to_ssm_policy"
  description = "Allows Lambda to send commands through SSM"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand"
        ]
        Resource = "*"
        # Resource = [
        #     aws_instance.ec2_instance.arn,
        #     data.aws_ssm_document.run_shell_script_document.arn
        # ]
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        # Resource = "*"
        Resource = [
            aws_sns_topic.stress_updates_topic.arn
        ]
      }
    ]
  })
}

resource aws_iam_role_policy_attachment lambda_send_command_to_ssm_policy_attachment {
  role       = aws_iam_role.lambda_ssm_role.name
  policy_arn = aws_iam_policy.lambda_send_command_to_ssm_policy.arn
}

resource aws_iam_role_policy_attachment lambda_send_logs_policy_attachment {
  role       = aws_iam_role.lambda_ssm_role.name
  policy_arn = data.aws_iam_policy.lambda_send_logs_policy.arn
}