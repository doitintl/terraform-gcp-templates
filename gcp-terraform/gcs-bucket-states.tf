resource "google_storage_bucket" "terraform_states" {
  name                        = format("terraform-automation-%s", var.shared_suffix)
  uniform_bucket_level_access = true
  project                     = google_project.terraform_automation.project_id
  location                    = var.region
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "terraform_states" {
  bucket = google_storage_bucket.terraform_states.name
  member = format("serviceAccount:%s", google_service_account.terraform.email)
  role   = "roles/storage.objectAdmin"
}