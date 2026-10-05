module trigger {
    source = "../../modules/trigger"
    
    aws_region               = var.aws_region
    ec2_instance = var.ec2_instance
    env_name = var.env_name
}