resource "google_monitoring_dashboard" "terraform_resources_dashboard" {
  project        = var.project_id
  dashboard_json = file("${path.module}/dashboard.json")
}

resource "google_monitoring_uptime_check_config" "terraform_resources_uptime_check" {
  project      = var.project_id
  display_name = "terraform-resources-uptime-check"

  http_check {
    path           = "/"
    port           = "80"
    use_ssl        = false
    request_method = "GET"

    accepted_response_status_codes {
      status_value = 200
    }
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = google_compute_global_forwarding_rule.host_vm_http_forwarding_rule.ip_address
    }
  }

  timeout = "5s"
  period  = "60s"
}

