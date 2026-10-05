resource aws_lambda_function lambda_function {
  filename      = data.archive_file.lambda_handler_zip.output_path
  function_name = "lambda_function"
  role          = aws_iam_role.lambda_ssm_role.arn
  handler       = "handler.handler"
  code_sha256   = data.archive_file.lambda_handler_zip.output_base64sha256

  runtime = "nodejs24.x"

  environment {
    variables = {
      ENVIRONMENT = var.env_name
      LOG_LEVEL   = "info"
      INSTANCE_ID = aws_instance.ec2_instance.id
    }
  }

  tags = {
    Environment = var.env_name
    Application = "${var.env_name}_lambda_function"
  }
}