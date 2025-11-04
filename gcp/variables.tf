# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "project" {
  description = "Name of the project."
  type        = string
}

variable "google_apis" {
  type = set(string)
  default = [
    "compute.googleapis.com",
    "iap.googleapis.com",
    "serviceusage.googleapis.com"
  ]
}

variable "environment" {
  description = "Name of the environment."
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Region."
  type        = string
  default     = "us-east1"
}

variable "network_name" {
  description = "Name of the network."
  type        = string
  default     = "instance-example"
}

variable "network_cidr" {
  description = "CIDR block for the network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "Private subnets for the network."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "machine_type" {
  description = "Machine type for instances."
  type        = string
  default     = "e2-micro"
}

variable "instances_per_subnet" {
  description = "Number of instances per private subnet."
  type        = number
  default     = 1
}
