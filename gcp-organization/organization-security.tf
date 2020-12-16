# IAM roles

# org
# resource "google_organization_iam_binding" "org_iam_org_admin" {
#   org     = var.org_id
#   role    = "roles/iam.organizationAdmin"
#
#   members = [
#     var.group_org_admins
#   ]
# }
#
# resource "google_organization_iam_binding" "org_iam_billing_admin" {
#   org     = var.org_id
#   role    = "roles/billing.admin"
#
#   members = [
#     var.group_billing_admins
#   ]
# }
#
# Billing Account User (tf-sa: org)
# resource "google_organization_iam_binding" "org_iam_billing_user" {
#   org     = var.org_id
#   role    = "roles/billing.user"
#
#   members = [
#     var.sa_terraform_admin
#   ]
# }
#
# Organization Policy Admin (tf-sa: org)
# resource "google_organization_iam_binding" "org_iam_org_policy_admin" {
#   org     = var.org_id
#   role    = "roles/orgpolicy.policyAdmin"
#
#   members = [
#     var.sa_terraform_admin
#   ]
# }
#
# Cloud Security Scanner Editor (security: org)
# resource "google_organization_iam_binding" "org_iam_security_scanner_editor" {
#   org     = var.org_id
#   role    = "roles/cloudsecurityscanner.editor"
#
#   members = [
#     var.group_security_admins
#   ]
# }

# TODO: change (org) scoped bindings to google_organization_iam_binding (non-playground-org)

# Viewer (security, network, devops: org)
resource "google_folder_iam_binding" "folder_iam_viewer" {
  folder = data.google_folder.root.id
  role   = "roles/viewer"
  members = flatten([
    var.group_security_admins,
    var.group_network_admins,
    var.group_devops
  ])
}

# Security Admin (security: org)
resource "google_folder_iam_binding" "folder_iam_security_admin" {
  folder  = data.google_folder.root.id
  role    = "roles/iam.securityAdmin"
  members = var.group_security_admins
}

# Compute Network Admin (network: org)

locals {
  network_admins_root_folder_iam_roles = toset([
    "roles/compute.networkAdmin",
    "roles/servicenetworking.networksAdmin",
    "roles/compute.xpnAdmin",
    "roles/logging.viewer",
    "roles/compute.securityAdmin",
    "roles/compute.orgSecurityPolicyAdmin",
  ])
}

resource "google_folder_iam_binding" "folder_iam_compute_network_admin" {
  for_each = local.network_admins_root_folder_iam_roles
  folder   = data.google_folder.root.id
  role     = each.value
  members  = var.group_network_admins
}

# BigQuery Data Viewer (billing: billing project)
resource "google_project_iam_binding" "project_iam_bq_data_viewer" {
  project = google_project.billing.project_id
  role    = "roles/bigquery.dataViewer"
  members = var.group_billing_admins
}

# Editor (security: security project)
resource "google_project_iam_binding" "project_iam_security_editor" {
  project = google_project.security.project_id
  role    = "roles/editor"
  members = var.group_security_admins
}

# Monitoring Admin (devops: monitoring project)
resource "google_project_iam_binding" "project_iam_monitoring_admin" {
  project = google_project.monitoring.project_id
  role    = "roles/monitoring.admin"
  members = var.group_devops
}

# Monitoring Viewer (dev: monitoring project)
resource "google_project_iam_binding" "project_iam_monitoring_viewer" {
  project = google_project.monitoring.project_id
  role    = "roles/monitoring.viewer"
  members = var.group_developers
}

# Kubernetes Engine Developer (dev: development project)
resource "google_project_iam_binding" "project_iam_container_developer" {
  project = google_project.development.project_id
  role    = "roles/container.developer"
  members = var.group_developers
}
