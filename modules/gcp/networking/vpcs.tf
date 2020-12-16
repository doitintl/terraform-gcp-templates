resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
  project                 = var.host_project_id
}
