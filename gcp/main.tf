# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "google" {
  project = var.project
}

resource "google_project_service" "apis" {
  for_each = var.google_apis

  service                    = each.value
  disable_on_destroy         = false
  disable_dependent_services = false
}

resource "tls_private_key" "instance" {
  depends_on = [google_project_service.apis]

  algorithm = "ED25519"
}

resource "google_compute_project_metadata" "ssh_keys" {
  metadata = {
    ssh-keys = "instance:${tls_private_key.instance.public_key_openssh}"
  }
}

resource "google_compute_network" "instance" {
  project                 = var.project
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "instance" {
  count = length(var.private_subnets)

  name          = "subnet-${var.environment}-${var.region}-${count.index}"
  region        = var.region
  network       = google_compute_network.instance.id
  ip_cidr_range = var.private_subnets[count.index]
}

data "google_compute_image" "noble_lts" {
  family  = "ubuntu-2404-lts-amd64"
  project = "ubuntu-os-cloud"
}

data "google_compute_zones" "available" {
  region = var.region
}

resource "random_pet" "instance_name" {
  count = length(google_compute_subnetwork.instance.*.id) * var.instances_per_subnet

  length    = 3
  separator = "-"
}

resource "random_shuffle" "zone" {
  input        = data.google_compute_zones.available.names
  result_count = 1
}

resource "google_compute_instance" "default" {
  count = length(google_compute_subnetwork.instance.*.id) * var.instances_per_subnet

  name         = random_pet.instance_name[count.index % length(google_compute_subnetwork.instance.*.id)].id
  machine_type = var.machine_type
  zone         = random_shuffle.zone.result[0]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.noble_lts.self_link
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.instance.*.id[count.index % length(google_compute_subnetwork.instance.*.id)]
    access_config {
    }
  }
}
