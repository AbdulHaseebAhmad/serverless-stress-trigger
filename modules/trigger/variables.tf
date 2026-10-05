variable aws_region {
    description = "The region in which the infra will be provisioned"
    type = string
}

variable env_name {
    description = "The environment name in which the infra is being provisioned"
    type = string
}

variable ec2_instance {
    description = "The ec2 instance that will be used to pull metrics"
    type = object({
        ami = string
        instance_type = string
        key_name = string 
    })
}