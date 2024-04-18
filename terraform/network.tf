# This file contains the terraform configuration to create a VPC network and a private service connection.
# This is used to create a private connection to the redis instance.

# The `google_compute_network` resource defines a VPC network named "image-text-extraction-vpc" with auto-create subnetworks enabled.
resource "google_compute_network" "vpc_network" {
  name = "image-text-extraction-vpc"
  auto_create_subnetworks = true
}

# The `google_compute_global_address` resource defines a global internal address named "address" with a prefix length of 16.
resource "google_compute_global_address" "service_range" {
  name = "address"
  purpose = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network = google_compute_network.vpc_network.name
}

# The `google_service_networking_connection` resource defines a private service connection to the "servicenetworking.googleapis.com" service using the VPC network and the reserved peering range.
resource "google_service_networking_connection" "private_service_connection" {
  network = google_compute_network.vpc_network.name
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.service_range.name]
}