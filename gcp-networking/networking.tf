module "networking_ranges" {
  source = "../modules/gcp/networking-ranges"
}

# Creates isolated VPCs and non-conflicting subnets within the shared-nw-prod GCP shared VPC project.
module "vpc_shared_networks_production" {
  source   = "../modules/gcp/networking"
  region   = var.region
  vpc_name = "production"

  host_project_id        = data.google_project.shared_network_production.project_id
  service_project_number = data.google_project.production.number

  subnet_dbs_ip_cidr_range          = module.networking_ranges.subnetworks.dbs.production
  subnet_k8s_nodes_ip_cidr_range    = module.networking_ranges.subnetworks.k8s_nodes.production
  subnet_k8s_pods_ip_cidr_range     = module.networking_ranges.subnetworks.k8s_pods.production
  subnet_k8s_services_ip_cidr_range = module.networking_ranges.subnetworks.k8s_services.production
  subnet_vms_ip_cidr_range          = module.networking_ranges.subnetworks.vms.production
}

module "vpc_shared_networks_staging" {
  source   = "../modules/gcp/networking"
  region   = var.region
  vpc_name = "staging"

  host_project_id        = data.google_project.shared_network_production.project_id
  service_project_number = data.google_project.staging.number

  subnet_dbs_ip_cidr_range          = module.networking_ranges.subnetworks.dbs.staging
  subnet_k8s_nodes_ip_cidr_range    = module.networking_ranges.subnetworks.k8s_nodes.staging
  subnet_k8s_pods_ip_cidr_range     = module.networking_ranges.subnetworks.k8s_pods.staging
  subnet_k8s_services_ip_cidr_range = module.networking_ranges.subnetworks.k8s_services.staging
  subnet_vms_ip_cidr_range          = module.networking_ranges.subnetworks.vms.staging
}

# Creates isolated VPCs and non-conflicting subnets within the shared-nw-non-prod GCP shared VPC project.
module "vpc_shared_networks_development" {
  source   = "../modules/gcp/networking"
  region   = var.region
  vpc_name = "development"

  host_project_id        = data.google_project.shared_network_non_production.project_id
  service_project_number = data.google_project.development.number

  subnet_dbs_ip_cidr_range          = module.networking_ranges.subnetworks.dbs.development
  subnet_k8s_nodes_ip_cidr_range    = module.networking_ranges.subnetworks.k8s_nodes.development
  subnet_k8s_pods_ip_cidr_range     = module.networking_ranges.subnetworks.k8s_pods.development
  subnet_k8s_services_ip_cidr_range = module.networking_ranges.subnetworks.k8s_services.development
  subnet_vms_ip_cidr_range          = module.networking_ranges.subnetworks.vms.development
}

## Shared VPCs hosts projects
resource "google_compute_shared_vpc_host_project" "shared_network_non_production" {
  project = data.google_project.shared_network_non_production.project_id
}

resource "google_compute_shared_vpc_host_project" "shared_network_production" {
  project = data.google_project.shared_network_production.project_id
}

## Shared VPC service projects
resource "google_compute_shared_vpc_service_project" "production" {
  host_project    = google_compute_shared_vpc_host_project.shared_network_production.project
  service_project = data.google_project.production.project_id
}

resource "google_compute_shared_vpc_service_project" "development" {
  host_project    = google_compute_shared_vpc_host_project.shared_network_non_production.project
  service_project = data.google_project.development.project_id
}

resource "google_compute_shared_vpc_service_project" "staging" {
  host_project    = google_compute_shared_vpc_host_project.shared_network_production.project
  service_project = data.google_project.staging.project_id
}

## Shared VPC IAM for GKE to work with Shared VPCs
resource "google_compute_subnetwork_iam_member" "shared_networks_production" {
  project    = module.vpc_shared_networks_production.host_project_id
  region     = module.vpc_shared_networks_production.subnet_k8s["region"]
  subnetwork = module.vpc_shared_networks_production.subnet_k8s["name"]
  role       = "roles/compute.networkUser"
  member = format(
    "serviceAccount:service-%s@container-engine-robot.iam.gserviceaccount.com",
    module.vpc_shared_networks_production.service_project_number,
  )
}

resource "google_compute_subnetwork_iam_member" "shared_networks_staging" {
  project    = module.vpc_shared_networks_staging.host_project_id
  region     = module.vpc_shared_networks_staging.subnet_k8s["region"]
  subnetwork = module.vpc_shared_networks_staging.subnet_k8s["name"]
  role       = "roles/compute.networkUser"
  member = format(
    "serviceAccount:service-%s@container-engine-robot.iam.gserviceaccount.com",
    module.vpc_shared_networks_staging.service_project_number,
  )
}

resource "google_compute_subnetwork_iam_member" "shared_networks_development" {
  project    = module.vpc_shared_networks_development.host_project_id
  region     = module.vpc_shared_networks_development.subnet_k8s["region"]
  subnetwork = module.vpc_shared_networks_development.subnet_k8s["name"]
  role       = "roles/compute.networkUser"
  member = format(
    "serviceAccount:service-%s@container-engine-robot.iam.gserviceaccount.com",
    module.vpc_shared_networks_development.service_project_number,
  )
}

## Private service networking
resource "google_compute_global_address" "private_service_connections_production" {
  name          = format("%s-private-networking", module.vpc_shared_networks_production.vpc.name)
  project       = module.vpc_shared_networks_production.host_project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc_shared_networks_production.vpc.id
}

resource "google_compute_global_address" "private_service_connections_staging" {
  name          = format("%s-private-networking", module.vpc_shared_networks_staging.vpc.name)
  project       = module.vpc_shared_networks_staging.host_project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc_shared_networks_staging.vpc.id
}

resource "google_compute_global_address" "private_service_connections_development" {
  name          = format("%s-private-networking", module.vpc_shared_networks_development.vpc.name)
  project       = module.vpc_shared_networks_development.host_project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc_shared_networks_development.vpc.id
}

resource "google_service_networking_connection" "private_service_connections_production" {
  network                 = module.vpc_shared_networks_production.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_connections_production.name]
}

resource "google_service_networking_connection" "private_service_connections_staging" {
  network                 = module.vpc_shared_networks_staging.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_connections_staging.name]
}

resource "google_service_networking_connection" "private_service_connections_development" {
  network                 = module.vpc_shared_networks_development.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_connections_development.name]
}
