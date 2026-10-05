resource aws_security_group ec2_security_group {
    name = "ec2_security_group"
    description = "this security group will be responsible for the ec2 that provides metrics"
    vpc_id      = data.aws_vpc.default.id

    ingress {
        to_port = 22
        from_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        to_port = 443
        from_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

      tags = {
    Name = "${var.env_name}_ec2_security_group"
    Environment = var.env_name
  }
}