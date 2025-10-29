# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider aws {
  region = var.aws_region

  default_tags {
    tags = var.default_tags
  }
}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "instance" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "instance" {
  public_key = tls_private_key.instance.public_key_openssh
}

module "instance" {
  source = "./modules/instance"

  network = {
      vpc_id             = module.vpc.vpc_id
      private_subnet_ids = module.vpc.private_subnets
      security_group_ids = [aws_security_group.allow_ssh.id]

  }
  key_name = aws_key_pair.instance.key_name
}
