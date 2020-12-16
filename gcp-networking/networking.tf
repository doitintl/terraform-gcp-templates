module "networking_ranges" {
  source = "../modules/gcp/networking-ranges"
}

# Creates isolated VPCs and non-conflicting subnets within the shared-network-production GCP shared VPC project.
module "vpc_shared_networks_production" {
  for_each = toset([
    data.google_project.production.name,
    data.google_project.staging.name,
  ])
  source   = "../modules/gcp/networking"
  region   = var.region
  vpc_name = each.value

  google_project_id     = data.google_project.shared_network_production.project_id
  google_project_number = data.google_project.shared_network_production.number

  subnet_dbs_ip_cidr_range          = module.networking_ranges.subnetworks.dbs[each.value]
  subnet_k8s_nodes_ip_cidr_range    = module.networking_ranges.subnetworks.k8s_nodes[each.value]
  subnet_k8s_pods_ip_cidr_range     = module.networking_ranges.subnetworks.k8s_pods[each.value]
  subnet_k8s_services_ip_cidr_range = module.networking_ranges.subnetworks.k8s_services[each.value]
  subnet_vms_ip_cidr_range          = module.networking_ranges.subnetworks.vms[each.value]
}

# Creates isolated VPCs and non-conflicting subnets within the shared-network-non-production GCP shared VPC project.
module "vpc_shared_networks_non_production" {
  for_each = toset([
    data.google_project.development.name,
    "devops",
  ])
  source   = "../modules/gcp/networking"
  region   = var.region
  vpc_name = each.value

  google_project_id     = data.google_project.shared_network_non_production.project_id
  google_project_number = data.google_project.shared_network_non_production.number

  subnet_dbs_ip_cidr_range          = module.networking_ranges.subnetworks.dbs[each.value]
  subnet_k8s_nodes_ip_cidr_range    = module.networking_ranges.subnetworks.k8s_nodes[each.value]
  subnet_k8s_pods_ip_cidr_range     = module.networking_ranges.subnetworks.k8s_pods[each.value]
  subnet_k8s_services_ip_cidr_range = module.networking_ranges.subnetworks.k8s_services[each.value]
  subnet_vms_ip_cidr_range          = module.networking_ranges.subnetworks.vms[each.value]
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
resource "google_compute_subnetwork_iam_member" "shared_networks" {
  for_each = setunion([
    module.vpc_shared_networks_production,
    module.vpc_shared_networks_non_production,
  ])
  project    = each.value.project_id
  region     = each.value.subnet_k8s["region"]
  subnetwork = each.value.subnet_k8s["name"]
  role       = "roles/compute.networkUser"
  member = format(
    "serviceAccount:service-%s@container-engine-robot.iam.gserviceaccount.com",
    each.value.project_number,
  )
}

## Private service networking
resource "google_compute_global_address" "private_service_connections" {
  for_each = setunion([
    module.vpc_shared_networks_non_production,
    module.vpc_shared_networks_production,
  ])
  name          = format("%s-private-networking", each.value.vpc["name"])
  project       = each.value.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = each.value.vpc["id"]
}

resource "google_service_networking_connection" "private_service_connections" {
  for_each = setunion([
    module.vpc_shared_networks_non_production,
    module.vpc_shared_networks_production,
  ])
  network                 = each.value.vpc["id"]
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_connections[each.key].name]
}
