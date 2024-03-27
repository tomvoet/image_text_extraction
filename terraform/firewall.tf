resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh-access"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "allow_redis" {
    name = "allow-redis-outbound"
    network = google_compute_network.vpc_network.name

    direction = "EGRESS"
    priority = 1000
    destination_ranges = ["0.0.0.0/0"]

    allow {
        protocol = "tcp"
        ports = ["6379"]
    }

    target_tags = ["redis-client"]
}