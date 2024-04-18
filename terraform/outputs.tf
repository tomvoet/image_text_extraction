# This file defines the output variables for the Terraform module.

# The IP address of the Redis instance.
output "redis_instance_ip" {
  value = google_redis_instance.redis.host
}

# The list of IP addresses of the host VM instances.
output "host_vm_ips" {
  value = [for instance in google_compute_instance.host_vm : instance.network_interface[0].access_config[0].nat_ip]
}

# The IP address of the load balancer.
output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.host_vm_http_forwarding_rule.ip_address
}
