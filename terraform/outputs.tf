output "redis_instance_ip" {
  value = google_redis_instance.redis.host
}

output "host_vm_ips" {
  value = [for instance in google_compute_instance.host_vm : instance.network_interface[0].access_config[0].nat_ip]
}

output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.host_vm_http_forwarding_rule.ip_address
}
