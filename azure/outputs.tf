output "private_key_pem" {
  description = "Private key material in PEM format."
  value       = tls_private_key.instance.private_key_pem
  sensitive   = true
}

output "public_key_pem" {
  description = "Public key material in PEM format."
  value       = tls_private_key.instance.public_key_pem
}

output "public_key_openssh" {
  description = "Public key material in openSSH format."
  value       = tls_private_key.instance.public_key_openssh
}

output "instance_ids" {
  description = "IDs of Linux virtual machines."
  value       = azurerm_linux_virtual_machine.private[*].id
}

output "private_ips" {
  description = "Private IP addresses of Linux virtual machines."
  value       = [for nic in azurerm_network_interface.private : nic.ip_configuration[0].private_ip_address]
}
