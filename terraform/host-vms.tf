/**
 * This Terraform configuration defines a Google Compute Engine instance resource.
 * It creates two instances of the specified machine type in the given zone.
 * The instances are created with a boot disk initialized with a Debian 12 image.
 * The instances have SSH access, Redis client, and HTTP server tags.
 * The instances are labeled with "google-ec-src=terraform".
 * The SSH key for the specified user is added to the instance metadata.
 * The instances are connected to the specified VPC network.
 */

resource "google_compute_instance" "host_vm" {
  count        = 2
  name         = "host-vm-${count.index}"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    auto_delete = true
    device_name = "host-vm"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240213"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  tags = ["ssh-access", "redis-client", "http-server"]

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    google-ec-src = "terraform"
  }

  metadata = {
    ssh-keys = "${var.user}:${file("/home/${var.user}/.ssh/id_rsa.pub")}"
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }
}
