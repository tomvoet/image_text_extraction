variable "project_id" {
  description = "The project ID to deploy resources"
  type = string
}

variable "user" {
  description = "The current user of this machine"
  type = string
}
# gcp
variable "region" {
  description = "The region to deploy resources"
  type = string
  default = "europe-west3"
}

variable "zone" {
  description = "The zone to deploy resources"
  type = string
  default = "europe-west3-a"
}
