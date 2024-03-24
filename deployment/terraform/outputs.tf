output "redis_instance_ip" {
  value = google_redis_instance.redis.host
}

output "host_vm_ip" {
  value = google_compute_instance.host_vm.network_interface[0].access_config[0].nat_ip
}
