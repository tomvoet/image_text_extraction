provider "google" {
  credentials = file("../service-account.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
