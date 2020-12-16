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
  members = [
    var.group_security_admins,
    var.group_network_admins,
    var.group_devops
  ]
}

# Security Admin (security: org)
resource "google_folder_iam_binding" "folder_iam_security_admin" {
  folder = data.google_folder.root.id
  role   = "roles/iam.securityAdmin"

  members = [
    var.group_security_admins
  ]
}

# Compute Network Admin (network: org) roles/compute.networkAdmin
resource "google_folder_iam_binding" "folder_iam_compute_network_admin" {
  folder = data.google_folder.root.id
  role   = "roles/compute.networkAdmin"

  members = [
    var.group_network_admins
  ]
}

# Service Networking Admin (network: org) roles/servicenetworking.networksAdmin
resource "google_folder_iam_binding" "folder_iam_service_networking_admin" {
  folder = data.google_folder.root.id
  role   = "roles/servicenetworking.networksAdmin"

  members = [
    var.group_network_admins
  ]
}

# Compute Shared VPC Admin (network, tf-sa: org)
resource "google_folder_iam_binding" "folder_iam_xpn_admin" {
  folder = data.google_folder.root.id
  role   = "roles/compute.xpnAdmin"

  members = [
    var.group_network_admins
  ]
}

# Logs Viewer (network: org)
resource "google_folder_iam_binding" "folder_iam_log_viewer" {
  folder = data.google_folder.root.id
  role   = "roles/compute.xpnAdmin"

  members = [
    var.group_network_admins
  ]
}

# Private Logs Viewer (security: org)
resource "google_folder_iam_binding" "folder_iam_private_log_viewer" {
  folder = data.google_folder.root.id
  role   = "roles/logging.viewer"

  members = [
    var.group_network_admins
  ]
}

# Compute Security Admin (security: org)
resource "google_folder_iam_binding" "folder_iam_compute_security_admin" {
  folder = data.google_folder.root.id
  role   = "roles/compute.securityAdmin"

  members = [
    var.group_network_admins
  ]
}

# Compute Organization Security Policy Admin (security: org)
resource "google_folder_iam_binding" "folder_iam_compute_org_security_policy_admin" {
  folder = data.google_folder.root.id
  role   = "roles/compute.orgSecurityPolicyAdmin"

  members = [
    var.group_network_admins
  ]
}

# BigQuery Data Viewer (billing: billing project)
resource "google_project_iam_binding" "project_iam_bq_data_viewer" {
  project = google_project.billing.project_id
  role    = "roles/bigquery.dataViewer"

  members = [
    var.group_billing_admins
  ]
}

# Editor (security: security project)
resource "google_project_iam_binding" "project_iam_security_editor" {
  project = google_project.security.project_id
  role    = "roles/editor"

  members = [
    var.group_security_admins
  ]
}

# Monitoring Admin (devops: monitoring project)
resource "google_project_iam_binding" "project_iam_monitoring_admin" {
  project = google_project.monitoring.project_id
  role    = "roles/monitoring.admin"

  members = [
    var.group_devops
  ]
}

# Monitoring Viewer (dev: monitoring project)
resource "google_project_iam_binding" "project_iam_monitoring_viewer" {
  project = google_project.monitoring.project_id
  role    = "roles/monitoring.viewer"

  members = [
    var.group_developers
  ]
}

# Kubernetes Engine Developer (dev: development project)
resource "google_project_iam_binding" "project_iam_container_developer" {
  project = google_project.development.project_id
  role    = "roles/container.developer"

  members = [
    var.group_developers
  ]
}
