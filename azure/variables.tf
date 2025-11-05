# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "Azure region for resource group."
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the VNET."
  type        = string
  default     = "instance-network"
}

variable "vnet_cidr" {
  description = "CIDR block for the VNET."
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "Private subnets for the VNET."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "Public subnets for the VNET."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "instances_per_subnet" {
  description = "Number of instances per private subnet."
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Instance type for all instances."
  type        = string
  default     = "Standard_B1s"
}
