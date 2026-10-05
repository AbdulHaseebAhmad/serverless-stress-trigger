resource aws_iam_instance_profile ec2_ssm_profile {
  name = "ec2_ssm_profile"
  role = aws_iam_role.ec2_ssm_role.name

    tags = {
    Name = "${var.env_name}_ec2_ssm_profile"
    Environment = var.env_name
  }
}