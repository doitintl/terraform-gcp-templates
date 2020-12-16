output "vpc" {
  value = google_compute_network.vpc
}

output "subnet_k8s" {
  value = google_compute_subnetwork.subnet_k8s
}

output "project_id" {
  value = var.google_project_id
}

output "project_number" {
  value = var.google_project_number
}