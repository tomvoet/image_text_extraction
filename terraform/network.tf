resource "google_compute_network" "vpc_network" {
  name = "image-text-extraction-vpc"
  auto_create_subnetworks = true
}

resource "google_compute_global_address" "service_range" {
  name = "address"
  purpose = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network = google_compute_network.vpc_network.name
}

resource "google_service_networking_connection" "private_service_connection" {
  network = google_compute_network.vpc_network.name
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.service_range.name]
}