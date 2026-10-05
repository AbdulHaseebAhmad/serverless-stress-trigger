data "aws_vpc" "default" {
  default = true
}

data aws_iam_policy ec2_ssm_policy {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data aws_iam_policy lambda_send_logs_policy {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data aws_ssm_document run_shell_script_document {
  name = "AWS-RunShellScript"
}

data archive_file lambda_handler_zip {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda_build/function.zip"
}