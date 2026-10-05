resource aws_instance ec2_instance {

  ami           = var.ec2_instance.ami
  instance_type = var.ec2_instance.instance_type
  key_name = var.ec2_instance.key_name
  
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  associate_public_ip_address = true

  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = file("${path.module}/templates/user-data.sh.tpl")

  tags = {
    Name = "${var.env_name}_ec2_instance"
    Environment = var.env_name
  }
}