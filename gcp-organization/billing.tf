resource "google_bigquery_dataset" "billing_dataset" {
  project       = google_project.billing.project_id
  dataset_id    = format("billing_export_%s", var.shared_suffix)
  friendly_name = "Billing Export"
  description   = "Exported billing data"
  location      = var.location
  labels        = { "dept" = "finance", "role" = "analytics" }

  delete_contents_on_destroy = true # destroying resource will fail otherwise

  depends_on = [google_project_service.billing]
}

resource "google_logging_billing_account_sink" "billing_bq_export" {
  name            = "billing-export"
  billing_account = var.billing_account_id
  destination = format(
    "bigquery.googleapis.com/projects/%s/datasets/%s",
    google_project.billing.project_id,
    google_bigquery_dataset.billing_dataset.dataset_id,
  )
}

resource "google_project_iam_binding" "billing_export_writer" {
  project = google_project.billing.project_id
  role    = "roles/bigquery.dataOwner"
  members = [google_logging_billing_account_sink.billing_bq_export.writer_identity, ]
}
