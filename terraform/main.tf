provider "google" {
  credentials = file("../service-account.json")
  project     = var.project_id
  region      = "eu-west1"
  zone        = "eu-west1-b"
}
