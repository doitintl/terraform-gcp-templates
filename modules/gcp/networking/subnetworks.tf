resource "google_compute_subnetwork" "subnet_k8s" {
  name          = "k8s-nodes"
  ip_cidr_range = var.subnet_k8s_nodes_ip_cidr_range
  region        = var.region
  project       = var.google_project_id
  network       = google_compute_network.vpc.id

  private_ip_google_access = true
  secondary_ip_range {
    range_name    = "k8s-pods"
    ip_cidr_range = var.subnet_k8s_pods_ip_cidr_range
  }
  secondary_ip_range {
    range_name    = "k8s-services"
    ip_cidr_range = var.subnet_k8s_services_ip_cidr_range
  }
}

resource "google_compute_subnetwork" "subnet_dbs" {
  name                     = "dbs"
  ip_cidr_range            = var.subnet_dbs_ip_cidr_range
  region                   = var.region
  project                  = var.google_project_id
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet_vms" {
  name                     = "vms"
  ip_cidr_range            = var.subnet_vms_ip_cidr_range
  region                   = var.region
  project                  = var.google_project_id
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}
