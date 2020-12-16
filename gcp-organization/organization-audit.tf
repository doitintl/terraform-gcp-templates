# audit config
resource "google_folder_iam_audit_config" "audit_root_folder" {
  folder  = format("folders/%s", data.google_folder.root.id)
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
}

# security
resource "google_project" "security" {
  name            = "security"
  project_id      = format("security-%s", var.shared_suffix)
  folder_id       = google_folder.shared_services.name
  billing_account = var.billing_account_id
  labels          = { "dept" : "infosec" }
}

# bucket for audit-logs, with log sink and dynamic sa role
resource "google_storage_bucket" "bucket_audit_logs" {
  name     = var.audit_logs_bucket_name
  location = var.location
  project  = google_project.security.project_id
  labels   = { "dept" : "infosec", "role" : "storage" }
}

resource "google_logging_folder_sink" "organization_logs_sink_audit" {
  name             = format("%s-audit-logs", replace(data.google_folder.root.name, "-", "_"))
  folder           = data.google_folder.root.name
  include_children = true
  destination      = format("storage.googleapis.com/%s", google_storage_bucket.bucket_audit_logs.name)
  filter           = "protoPayload.@type:\"type.googleapis.com/google.cloud.audit.AuditLog\""
}

resource "google_project_iam_binding" "audit_log_writer" {
  project = google_project.security.project_id
  role    = "roles/storage.objectCreator"
  members = [
    google_logging_folder_sink.organization_logs_sink_audit.writer_identity,
  ]
}
