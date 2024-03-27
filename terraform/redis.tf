#resource "google_redis_instance" "redis" {
#    name = "image-text-extraction-redis"
#    tier = "BASIC"
#    memory_size_gb = 1
#
#    location_id = var.zone
#    authorized_network = google_compute_network.vpc_network.name
#}
resource "google_redis_instance" "redis" {
    name = "image-text-extraction-redis"
    tier = "BASIC"
    memory_size_gb = 1

    location_id = var.zone
    authorized_network = google_compute_network.vpc_network.name
    connect_mode = "PRIVATE_SERVICE_ACCESS"

    depends_on = [ google_service_networking_connection.private_service_connection ]
}