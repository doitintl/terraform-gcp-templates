output "vpc" {
  value = google_compute_network.vpc
}

output "subnet_k8s" {
  value = google_compute_subnetwork.subnet_k8s
}

output "host_project_id" {
  value = var.host_project_id
}

output "service_project_number" {
  value = var.service_project_number
}