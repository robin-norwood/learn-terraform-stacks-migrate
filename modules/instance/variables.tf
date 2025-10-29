variable "network" {
  description = "VPC configuration."
  type = object({
    vpc_id             = string
    private_subnet_ids = list(string)
    security_group_ids = list(string)
  })
}

variable "key_name" {
  description = "Name of the AWS EC2 key pair to use to login to the EC2 instances."
  type        = string
}

variable "instances_per_subnet" {
  description = "Number of instances per private subnet."
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Instance type for all instances."
  type        = string
  default     = "t2.micro"
}

