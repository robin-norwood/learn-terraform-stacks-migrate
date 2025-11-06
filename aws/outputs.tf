# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "intance_ids" {
  description = "EC2 instance IDs"
  value       = module.instance.instance_ids
}

output "intance_private_dns" {
  description = "EC2 instance Private DNS names"
  value       = module.instance.private_dns
}
