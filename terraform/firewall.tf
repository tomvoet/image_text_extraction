# This file contains the configuration for the firewall rules that are used to control traffic to and from the instances in the VPC network.

# This resource allows inbound SSH traffic on port 22 from any source IP address.
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-access"]
}

# This resource allows outbound TCP traffic on port 6379 to any destination IP address.
# It is used for allowing Redis client connections.
resource "google_compute_firewall" "allow_redis" {
  name    = "allow-redis-outbound"
  network = google_compute_network.vpc_network.name

  direction          = "EGRESS"
  priority           = 1000
  destination_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }

  target_tags = ["redis-client"]
}

# This resource allows inbound TCP traffic on port 80 from specific source IP ranges.
# It is used for allowing health checks from Google Cloud Load Balancers.
resource "google_compute_firewall" "allow_health_check" {
  name    = "allow-health-check"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"] # see https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges
  target_tags   = ["http-server"]
}
