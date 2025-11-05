# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.50.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.1.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.7.2"
    }    
  }

  cloud {
    organization = "your-organization-name"

    workspaces {
      name = "learn-terraform-stacks-migrate"
    }
  }

  required_version = "~> 1.13"
}
