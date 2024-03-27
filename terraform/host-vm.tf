resource "google_compute_instance" "host_vm" {
  name         = "host-vm"
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

  tags = ["http-server", "ssh-access", "redis-client"]

  can_ip_forward = false
  deletion_protection = false
  enable_display = false

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
