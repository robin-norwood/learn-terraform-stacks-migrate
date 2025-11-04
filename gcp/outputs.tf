# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "private_key" {
  description = "Private key material in PEM format."
  value       = tls_private_key.instance.private_key_pem
  sensitive   = true
}

output "network_id" {
  description = "The network ID."
  value       = google_compute_network.instance.id
}

output "network_name" {
  description = "Network name."
  value       = google_compute_network.instance.name
}

output "instance_ips" {
  description = "IPs of instances."
  value       = google_compute_instance.default.*.network_interface.0.network_ip 
}
