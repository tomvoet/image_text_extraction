resource "google_compute_health_check" "http" {
  name = "http-basic-check"
  http_health_check {
    port = 80
  }
}

resource "google_compute_instance_group" "host_vms" {
  name = "host-vm-group"
  zone = var.zone

  named_port {
    name = "http"
    port = 80
  }

  instances = [for instance in google_compute_instance.host_vm : instance.self_link]
}

resource "google_compute_backend_service" "host_vm_backend_service" {
  name     = "host-vm-backend-service"
  protocol = "HTTP"

  health_checks = [google_compute_health_check.http.self_link]

  backend {
    group = google_compute_instance_group.host_vms.self_link
  }
}

resource "google_compute_url_map" "host_vm_url_map" {
  name            = "host-vm-url-map"
  default_service = google_compute_backend_service.host_vm_backend_service.self_link
}

resource "google_compute_target_http_proxy" "host_vm_http_proxy" {
  name    = "host-vm-http-proxy"
  url_map = google_compute_url_map.host_vm_url_map.self_link
}

resource "google_compute_global_forwarding_rule" "host_vm_http_forwarding_rule" {
  name       = "host-vm-http-forwarding-rule"
  target     = google_compute_target_http_proxy.host_vm_http_proxy.self_link
  port_range = "80"
}
