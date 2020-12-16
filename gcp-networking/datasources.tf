data "google_project" "shared_network_production" {
  project_id = format("shared-nw-prod-%s", var.shared_suffix)
}

data "google_project" "shared_network_non_production" {
  project_id = format("shared-nw-non-prod-%s", var.shared_suffix)
}

data "google_project" "production" {
  project_id = format("production-%s", var.shared_suffix)
}

data "google_project" "staging" {
  project_id = format("staging-%s", var.shared_suffix)
}

data "google_project" "development" {
  project_id = format("development-%s", var.shared_suffix)
}