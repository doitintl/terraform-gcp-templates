## Shared services projects

# production (Shared VPC Host project)
resource "google_project" "shared_network_production" {
  name      = "shared-nw-prod"
  folder_id = google_folder.shared_services.name
  project_id = format(
    "shared-nw-prod-%s",
    var.shared_suffix,
  )
  billing_account = var.billing_account_id
  labels = {
    "dept" = "network"
    "env"  = "production"
  }
}

# non-production (Shared VPC Host project)
resource "google_project" "shared_network_non_production" {
  name      = "shared-nw-non-prod"
  folder_id = google_folder.shared_services.name
  project_id = format(
    "shared-nw-non-prod-%s",
    var.shared_suffix,
  )
  billing_account = var.billing_account_id
  labels = {
    "dept" = "network"
    "env"  = "non-production"
  }
}

# monitoring
resource "google_project" "monitoring" {
  name            = "monitoring"
  project_id      = format("monitoring-%s", var.shared_suffix)
  folder_id       = google_folder.shared_services.name
  billing_account = var.billing_account_id
  labels = {
    "dept" = "engineering"
  }
}

# billing exports
resource "google_project" "billing" {
  name            = "billing"
  project_id      = format("billing-%s", var.shared_suffix)
  folder_id       = google_folder.shared_services.name
  billing_account = var.billing_account_id
  labels = {
    "dept" = "finance"
  }
}

## Isolated projects
# dev
resource "google_project" "development" {
  name            = "development"
  project_id      = format("development-%s", var.shared_suffix)
  folder_id       = google_folder.non_production.name
  billing_account = var.billing_account_id
  labels = {
    "dept"    = "engineering"
    "env"     = "non-production"
    "product" = "x"
  }
}

# staging
resource "google_project" "staging" {
  name            = "staging"
  project_id      = format("staging-%s", var.shared_suffix)
  folder_id       = google_folder.non_production.name
  billing_account = var.billing_account_id
  labels = {
    "dept"    = "engineering"
    "env"     = "non-production"
    "product" = "x"
  }
}

# production
resource "google_project" "production" {
  name            = "production"
  project_id      = format("production-%s", var.shared_suffix)
  folder_id       = google_folder.production.name
  billing_account = var.billing_account_id
  labels = {
    "dept"    = "engineering"
    "env"     = "production"
    "product" = "x"
  }
}

# Google API enabled services

locals {
  shared_projects_common_api_services = toset([
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
  ])
  isolated_projects_common_api_services = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
  ])
  billing_project_services = toset([
    "billingbudgets.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "bigquery.googleapis.com", # NOTE: must enable 'Logs Configuration Writer' for tf-sa on billing acct
  ])
  monitoring_project_services = toset([
    "monitoring.googleapis.com",
  ])
}

resource "google_project_service" "shared_network_production" {
  for_each = local.shared_projects_common_api_services
  project  = google_project.shared_network_production.project_id
  service  = each.value
}

resource "google_project_service" "shared_network_non_production" {
  for_each = local.shared_projects_common_api_services
  project  = google_project.shared_network_non_production.project_id
  service  = each.value
}

resource "google_project_service" "billing" {
  for_each                   = local.billing_project_services
  project                    = google_project.billing.project_id
  service                    = each.value
  disable_dependent_services = true
}

resource "google_project_service" "monitoring" {
  for_each = local.monitoring_project_services
  project  = google_project.monitoring.project_id
  service  = each.value
}

resource "google_project_service" "development" {
  for_each = local.isolated_projects_common_api_services
  project  = google_project.development.project_id
  service  = each.value
}

resource "google_project_service" "staging" {
  for_each = local.isolated_projects_common_api_services
  project  = google_project.staging.project_id
  service  = each.value
}

resource "google_project_service" "production" {
  for_each = local.isolated_projects_common_api_services
  project  = google_project.production.project_id
  service  = each.value
}
